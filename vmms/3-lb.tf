#/*
resource "azurerm_public_ip" "test" {
  name                = "TestPip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "test" {
  name                = "SimlpleLBTest"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "FrontPipforSimpleLBTest"
    public_ip_address_id = azurerm_public_ip.test.id
  }
}

resource "azurerm_lb_backend_address_pool" "test" {
  name            = "Test-backend"
  loadbalancer_id = azurerm_lb.test.id
}

resource "azurerm_lb_probe" "test" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.test.id
}

resource "azurerm_lb_rule" "test_rule_app1" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.test.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.test.id]
  probe_id                       = azurerm_lb_probe.test.id
  loadbalancer_id                = azurerm_lb.test.id
}


# AS VMSS network inteface itself can associate with backend pools
# resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
#   for_each                = var.no_of_instance
#   network_interface_id    = azurerm_network_interface.example[each.key].id #element(azurerm_network_interface.example[*].id, count.index)
#   ip_configuration_name   = azurerm_network_interface.example[each.key].ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.test.id
# }
#*/
