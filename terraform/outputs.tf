output "timeapp_url" {
  value = "http://${module.timeapp.timeapp_fqdn}/now"
}
