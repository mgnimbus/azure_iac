# variable "web_vmss_nsg_ports" {
#   description = "Inbound ports for VMMS"
#   type        = list(string)
#   default     = ["22", "80"]
# }

# resource "azurerm_network_security_group" "vmms_nsg" {
#   name                = "Web-VMMS-SecurityGroup1"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   dynamic "security_rule" {
#     for_each = toset(var.web_vmss_nsg_ports)
#     content {
#       name                       = "Alllow-${security_rule.key}-port-for-VMMS"
#       priority                   = sum([100, security_rule.key])
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = security_rule.value
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   }
# }

locals {
  app_data = <<CUSTOM_DATA
    #!/bin/sh
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo systemctl start httpd  
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo chmod -R 777 /var/www/html 
    sudo echo "Welcome to mgm-tf-farm - App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
    sudo mkdir /var/www/html/app1
    sudo echo "mgm-tf-farm - App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
    sudo echo "mgm-tf-farm - App1 - App Status Page" > /var/www/html/app1/status.html
    sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>mgm-tf-farm - App1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
    sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
  CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "web-vmss"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard_DS1_v2"
  instances           = 2
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/keys/tf-azure.pub")
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  upgrade_mode = "Automatic"

  network_interface {
    name    = "NicForWebVMSS"
    primary = true
    #network_security_group_id = azurerm_network_security_group.vmms_nsg.id

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.example.id

      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.test.id]
    }
  }
  custom_data = base64encode(local.app_data)
}
