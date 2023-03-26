resource "azurerm_subnet" "example1" {
  name                 = "bass_subs"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_network_security_group" "example1" {
  name                = "MyBaseSecurityGroup"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
locals {
  sg-port-base = {
    100 : 22,
  }

}

resource "azurerm_network_security_rule" "example1" {
  for_each                    = local.sg-port
  name                        = "base-sg-rule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example1.name
}

resource "azurerm_subnet_network_security_group_association" "example1" {
  subnet_id                 = azurerm_subnet.example1.id
  network_security_group_id = azurerm_network_security_group.example1.id
  depends_on = [
    azurerm_network_security_rule.example1
  ]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion-publicip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#NicAssociationBaseVM
resource "azurerm_network_interface" "example1" {
  name                = "base-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name


  ip_configuration {
    name                          = "bastion-host-ip"
    subnet_id                     = azurerm_subnet.example1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}


resource "azurerm_linux_virtual_machine" "example1" {
  name                = "MyBassLinuxMacie"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.example1.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/keys/tf-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
}

# resource "azurerm_lb_nat_rule" "example" {
#   for_each                       = var.no_of_instance
#   name                           = "${each.key}-ssh-${each.value}-vm-22"
#   protocol                       = "Tcp"
#   frontend_port                  = lookup(var.no_of_instance, each.key) #each.value
#   backend_port                   = 22
#   resource_group_name            = azurerm_resource_group.example.name
#   loadbalancer_id                = azurerm_lb.test.id
#   frontend_ip_configuration_name = azurerm_lb.test.frontend_ip_configuration[0].name
#   depends_on                     = [azurerm_linux_virtual_machine_scale_set.web_vmss]
# }


# # Associate LB NAT Rule and VM Network Interface
# resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
#   for_each              = var.no_of_instance
#   network_interface_id  = azurerm_network_interface.example[each.key].id
#   ip_configuration_name = azurerm_network_interface.example[each.key].ip_configuration[0].name
#   nat_rule_id           = azurerm_lb_nat_rule.example[each.key].id
#   #   network_interface_id  = element(azurerm_network_interface.web[*].id, count.index)
#   #   ip_configuration_name = element(azurerm_network_interface.web[*].ip_configuration[0].name, count.index)
#   #   nat_rule_id           = element(azurerm_lb_nat_rule.example[*].id, count.index)
# }
