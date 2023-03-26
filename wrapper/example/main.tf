provider "azurerm" {
  features {}
}

resource "random_pet" "randy" {
  length = 1
}
resource "azurerm_resource_group" "example" {
  name     = "terraform-farm-${random_pet.randy.id}"
  location = "East US"
}


module "linuxserver" {
  #source              = "Azure/compute/azurerm"
  source                           = "../vm_wrapper"
  vm_hostname                      = "linux-machie"
  resource_group_name              = azurerm_resource_group.example.name
  vm_os_publisher                  = "RedHat"
  vm_os_offer                      = "RHEL"
  vm_os_sku                        = "86-gen2"
  vm_os_version                    = "latest"
  remote_port                      = "80"
  nb_public_ip                     = 0
  custom_data                      = base64encode(local.app_data)
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  enable_ssh_key                   = true
  admin_username                   = "azureuser"
  ssh_key                          = fileexists("~/.ssh/id_rsa.pub") ? "~/.ssh/id_rsa.pub" : ""
  extra_ssh_keys                   = ["tf-azure.pub"]
  identity_type                    = ""
  admin_password                   = "Champion@2"

  #public_ip_dns                    = ["linsimplevmips${random_pet.randy.id}"] // change to a unique name per datacenter region
  depends_on = [azurerm_resource_group.example]
}

module "network" {
  source              = "Azure/network/azurerm"
  use_for_each        = false
  resource_group_name = azurerm_resource_group.example.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.example]
}

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

module "mylb" {
  source              = "../lb_wrapper"
  create_lb           = true
  resource_group_name = azurerm_resource_group.example.name
  prefix              = "tf-testLBMod"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["80", "Tcp", "80"]
  }

  lb_probe = {
    http = ["Tcp", "80", ""]
  }

}

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = module.linuxserver.network_interface_ids[0]
  ip_configuration_name   = "linux-machie-ip-0"
  backend_address_pool_id = module.mylb.backend_address_pool_id
  depends_on = [
    module.linuxserver
  ]
}
