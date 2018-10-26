#cloud-config
manage_etc_hosts: false

write_files:
  - content: |
      set -x
      sudo docker-compose -f /opt/timeapp/docker-compose.yml up -d
    path: /opt/start_timeapp.sh
    permissions: '0750'

runcmd:
  - /opt/start_timeapp.sh

