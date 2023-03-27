module "vm-wrapper" {
  source                 = "Azure/compute/azurerm"
  location               = var.location
  vm_hostname            = var.vm_hostname
  name_template_vm_linux = var.name_template_vm_linux
  resource_group_name    = var.resource_group_name
  vnet_subnet_id         = var.vnet_subnet_id

  nb_public_ip            = var.nb_public_ip
  allocation_method       = var.allocation_method
  name_template_public_ip = var.name_template_public_ip
  public_ip_dns           = var.public_ip_dns
  public_ip_sku           = var.public_ip_sku

  network_security_group               = var.network_security_group
  name_template_network_security_group = var.name_template_network_security_group
  remote_port                          = var.remote_port
  source_address_prefixes              = var.source_address_prefixes

  enable_accelerated_networking = var.enable_accelerated_networking

  nb_instances                     = var.nb_instances
  vm_size                          = var.vm_size
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  tags                             = var.tags
  zone                             = var.zone

  storage_os_disk_size_gb = var.storage_os_disk_size_gb
  storage_account_type    = var.storage_account_type

  boot_diagnostics                  = var.boot_diagnostics
  external_boot_diagnostics_storage = var.external_boot_diagnostics_storage
  boot_diagnostics_sa_type          = var.boot_diagnostics_sa_type

  identity_ids  = var.identity_ids
  identity_type = var.identity_type

  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = var.custom_data

  enable_ssh_key = var.enable_ssh_key
  ssh_key        = var.ssh_key
  ssh_key_values = var.ssh_key_values
  extra_ssh_keys = var.extra_ssh_keys

  os_profile_secrets = var.os_profile_secrets

  is_marketplace_image = var.is_marketplace_image
  vm_os_simple         = var.vm_os_simple
  vm_os_sku            = var.vm_os_sku
  vm_os_offer          = var.vm_os_offer
  vm_os_publisher      = var.vm_os_publisher
  vm_os_version        = var.vm_os_version

  vm_os_id = var.vm_os_id

  #windows_server
  license_type                     = var.license_type
  is_windows_image                 = var.is_windows_image
  name_template_vm_windows_os_disk = var.name_template_vm_windows_os_disk

  nb_data_disk                        = var.nb_data_disk
  extra_disks                         = var.extra_disks
  name_template_data_disk             = var.name_template_data_disk
  nested_data_disks                   = var.nested_data_disks
  managed_data_disk_encryption_set_id = var.managed_data_disk_encryption_set_id
  data_disk_size_gb                   = var.data_disk_size_gb
  name_template_extra_disk            = var.name_template_extra_disk
  name_template_network_interface     = var.name_template_network_interface
  data_sa_type                        = var.data_sa_type

  availability_set_enabled        = var.availability_set_enabled
  name_template_availability_set  = var.name_template_availability_set
  as_platform_fault_domain_count  = var.as_platform_fault_domain_count
  as_platform_update_domain_count = var.as_platform_update_domain_count

  vm_extension  = var.vm_extension
  vm_extensions = var.vm_extensions
}

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
  allocation_method = var.allocation_method_lb
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
  remote_port = var.remote_port_nat

  #lb_probe
  lb_probe                     = var.lb_probe
  lb_probe_interval            = var.lb_probe_interval
  lb_probe_unhealthy_threshold = var.lb_probe_unhealthy_threshold

  #lb_rule
  lb_port                = var.lb_port
  disable_outbound_snat  = var.disable_outbound_snat
  lb_floating_ip_enabled = var.lb_floating_ip_enabled
}
