terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_pet" "randy1" {
  length = 1
}

resource "azurerm_resource_group" "example" {
  name     = "terraform-farm-${random_pet.randy1.id}"
  location = "East US"
}


resource "azurerm_virtual_network" "example" {
  name                = "mgm-net"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = "Test"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "subs"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "MySecurityGroup"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
locals {
  sg-port = {
    100 : 22,
    110 = 80
  }

}

resource "azurerm_network_security_rule" "example" {
  for_each                    = local.sg-port
  name                        = "sg-rule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
  depends_on = [
    azurerm_network_security_rule.example
  ]
}
