resource "azurerm_lb_nat_rule" "example" {
  count                          = var.no_of_instance
  name                           = "WebVMAccess-${count.index}-ssh"
  protocol                       = "Tcp"
  frontend_port                  = element(["1022", "2022", "3022"], count.index)
  backend_port                   = 22
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.test.id
  frontend_ip_configuration_name = azurerm_lb.test.frontend_ip_configuration[0].name
  depends_on                     = [azurerm_linux_virtual_machine.example]
}


# Associate LB NAT Rule and VM Network Interface
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  count                 = var.no_of_instance
  network_interface_id  = azurerm_network_interface.example[count.index].id
  ip_configuration_name = azurerm_network_interface.example[count.index].ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.example[count.index].id
  #   network_interface_id  = element(azurerm_network_interface.web[*].id, count.index)
  #   ip_configuration_name = element(azurerm_network_interface.web[*].ip_configuration[0].name, count.index)
  #   nat_rule_id           = element(azurerm_lb_nat_rule.example[*].id, count.index)
}
