provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "test" {
  name = "test-vm-lb-internal"
}

module "network" {
  source              = "Azure/network/azurerm"
  use_for_each        = false
  resource_group_name = data.azurerm_resource_group.test.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "Subnet-SecurityGroup"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name

  dynamic "security_rule" {
    for_each = toset([80, 443])
    content {
      name                       = "Allow-${security_rule.key}-port"
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "random_password" "admin_password" {
  length      = 20
  lower       = true
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  min_upper   = 1
  numeric     = true
  special     = true
  upper       = true
}

module "vm_lb_int" {
  source                           = "../"
  vm_hostname                      = "linux-test-int"
  resource_group_name              = data.azurerm_resource_group.test.name
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  vm_os_publisher                  = var.vm_os_publisher
  vm_os_offer                      = var.vm_os_offer
  vm_os_sku                        = var.vm_os_sku
  vm_os_version                    = var.vm_os_version
  admin_username                   = "azureuser"
  admin_password                   = local.admin_password
  network_security_group           = local.network_security_group
  custom_data                      = base64encode(local.app_data)
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  #lb
  name                                   = "lb-int-test"
  type                                   = "private"
  frontend_subnet_id                     = module.network.vnet_subnets[0]
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.0.1.200"
  lb_sku                                 = "Standard"
  lb_port                                = var.lb_port
  lb_probe                               = var.lb_probe
}

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = module.vm_lb_int.network_interface_ids[0]
  ip_configuration_name   = "linux-test-int-ip-0"
  backend_address_pool_id = module.vm_lb_int.backend_address_pool_id
  depends_on              = [module.vm_lb_int]
}
