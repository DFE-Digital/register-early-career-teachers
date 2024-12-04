module "statuscake" {
  source = "./vendor/modules/aks//monitoring/statuscake"
  count  = var.enable_monitoring ? 1 : 0

  uptime_urls    = [var.external_url]
  ssl_urls       = [var.external_url]
  contact_groups = var.statuscake_contact_groups
}
