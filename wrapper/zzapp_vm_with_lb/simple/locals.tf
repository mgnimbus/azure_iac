locals {
  admin_password = coalesce(var.admin_password, random_password.admin_password.result)
  network_security_group = {
    id = azurerm_network_security_group.nsg.id
  }
}
