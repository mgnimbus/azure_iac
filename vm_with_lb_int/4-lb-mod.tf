module "mylb" {
  source                                 = "Azure/loadbalancer/azurerm"
  resource_group_name                    = azurerm_resource_group.example.name
  name                                   = "lb-aztest"
  type                                   = "private"
  frontend_subnet_id                     = azurerm_subnet.example.id
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.1.1.200"
  lb_sku                                 = "Standard"

  lb_port = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }

  lb_probe = {
    http  = ["Tcp", "80", ""]
    http2 = ["Http", "1443", "/"]
  }

}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_associate" {
  network_interface_id    = azurerm_network_interface.example.id
  ip_configuration_name   = azurerm_network_interface.example.ip_configuration[0].name
  backend_address_pool_id = module.mylb.azurerm_lb_backend_address_pool_id
}
