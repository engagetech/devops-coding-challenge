# Instance templates
data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}

# Security groups
resource "aws_security_group" "timeapp-sg" {
  name   = "${lower(var.environment)}-${lower(var.service_name)}-sg"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-sg"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_security_group" "public-lb-sg" {
  name   = "${var.environment}-${var.service_name}-elb-pub-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-${var.service_name}-lb-pub-sg"
    environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "timeapp-allow-lb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.public-lb-sg.id}"

  security_group_id = "${aws_security_group.timeapp-sg.id}"
}

# ALB , listener and target group

resource "aws_lb" "timeapp" {
  name               = "${lower(var.environment)}-${lower(var.service_name)}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.public-lb-sg.id}"]
  subnets            = ["${compact(split(",",var.vpc_public_subnet_ids))}"]

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_lb_target_group" "timeapp" {
  name     = "${var.environment}-${var.service_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = "${var.lb_health_check_interval}"
    timeout             = "${var.lb_health_check_timeout}"
    path                = "${var.lb_health_check_path}"
    healthy_threshold   = "${var.lb_health_check_healthy_threshold}"
    unhealthy_threshold = "${var.lb_health_check_unhealthy_threshold}"
    matcher             = "${var.lb_health_check_matcher}"
  }

  tags {
    Name        = "${var.environment}-${var.service_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "timeapp" {
  load_balancer_arn = "${aws_lb.timeapp.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.timeapp.arn}"
    type             = "forward"
  }
}

# Launch configuration and Auto scaling group

resource "aws_launch_configuration" "timeapp" {
  name_prefix     = "${lower(var.environment)}-${lower(var.service_name)}-"
  instance_type   = "${var.ec2_instance_type}"
  security_groups = ["${aws_security_group.timeapp-sg.id}"]
  image_id        = "${var.ec2_ami_id}"
  key_name        = "${var.ec2_keypair}"

  user_data = "${data.template_file.init.rendered}"

  root_block_device {
    volume_type = "${var.ebs_root_volume_type}"
    volume_size = "${var.ebs_root_volume_size}"
    iops        = "${var.ebs_root_volume_iops}"
  }
}

resource "aws_autoscaling_group" "timeapp" {
  name                      = "${lower(var.environment)}-${lower(var.service_name)}"
  vpc_zone_identifier       = ["${element(compact(split(",",var.vpc_private_subnet_ids)), count.index)}"]
  launch_configuration      = "${aws_launch_configuration.timeapp.name}"
  default_cooldown          = "${var.asg_default_cooldown}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"

  min_size         = "${var.min_instances}"
  max_size         = "${var.max_instances}"
  desired_capacity = "${var.desired_instances}"

  target_group_arns = ["${aws_lb_target_group.timeapp.arn}"]

  tag {
    key                 = "Name"
    value               = "${lower(var.environment)}-${lower(var.service_name)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${lower(var.environment)}"
    propagate_at_launch = true
  }
}

resource "aws_route53_record" "public_elb" {
  zone_id = "${var.dns_public_zone_id}"
  name    = "${lower(var.service_name)}"
  type    = "A"

  alias {
    name                   = "${aws_lb.timeapp.dns_name}"
    zone_id                = "${aws_lb.timeapp.zone_id}"
    evaluate_target_health = false
  }
}
