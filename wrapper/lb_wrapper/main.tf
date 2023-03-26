module "lb_wrapper" {
  source = "Azure/loadbalancer/azurerm"
  count  = var.create_lb ? 1 : 0
  #subnet
  frontend_subnet_name = var.frontend_subnet_name
  frontend_vnet_name   = var.frontend_vnet_name

  name                = var.name
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  type                = var.type

  #Pip
  allocation_method = var.allocation_method
  location          = var.location
  pip_name          = var.pip_name

  pip_ddos_protection_mode    = var.pip_ddos_protection_mode
  pip_ddos_protection_plan_id = var.pip_ddos_protection_plan_id
  pip_domain_name_label       = var.pip_domain_name_label
  edge_zone                   = var.edge_zone
  pip_idle_timeout_in_minutes = var.pip_idle_timeout_in_minutes
  pip_ip_tags                 = var.pip_ip_tags
  pip_ip_version              = var.pip_ip_version
  pip_public_ip_prefix_id     = var.pip_public_ip_prefix_id
  pip_reverse_fqdn            = var.pip_reverse_fqdn
  pip_sku                     = var.pip_sku
  pip_sku_tier                = var.pip_sku_tier
  pip_zones                   = var.pip_zones
  tags                        = var.tags

  #lb
  lb_sku      = var.lb_sku
  lb_sku_tier = var.lb_sku_tier

  frontend_name                          = var.frontend_name
  frontend_private_ip_address            = var.frontend_private_ip_address
  frontend_private_ip_address_allocation = var.frontend_private_ip_address_allocation
  frontend_private_ip_address_version    = var.frontend_private_ip_address_version
  frontend_subnet_id                     = var.frontend_subnet_id

  #nat_rule
  remote_port = var.remote_port

  #lb_probe
  lb_probe                     = var.lb_probe
  lb_probe_interval            = var.lb_probe_interval
  lb_probe_unhealthy_threshold = var.lb_probe_unhealthy_threshold

  #lb_rule
  lb_port                = var.lb_port
  disable_outbound_snat  = var.disable_outbound_snat
  lb_floating_ip_enabled = var.lb_floating_ip_enabled
}
