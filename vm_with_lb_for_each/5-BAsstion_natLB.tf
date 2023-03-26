resource "azurerm_lb_nat_rule" "example" {
  for_each                       = var.no_of_instance
  name                           = "${each.key}-ssh-${each.value}-vm-22"
  protocol                       = "Tcp"
  frontend_port                  = lookup(var.no_of_instance, each.key) #each.value
  backend_port                   = 22
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.test.id
  frontend_ip_configuration_name = azurerm_lb.test.frontend_ip_configuration[0].name
  depends_on                     = [azurerm_linux_virtual_machine.example]
}


# Associate LB NAT Rule and VM Network Interface
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  for_each              = var.no_of_instance
  network_interface_id  = azurerm_network_interface.example[each.key].id
  ip_configuration_name = azurerm_network_interface.example[each.key].ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.example[each.key].id
  #   network_interface_id  = element(azurerm_network_interface.web[*].id, count.index)
  #   ip_configuration_name = element(azurerm_network_interface.web[*].ip_configuration[0].name, count.index)
  #   nat_rule_id           = element(azurerm_lb_nat_rule.example[*].id, count.index)
}
