output "vm_ids" {
  description = "Virtual machine ids created."
  value       = module.linuxserver.vm_ids
}

output "vm_names" {
  description = "Virtual machine names created."
  value       = module.linuxserver.vm_names.linux
}

output "network_interface_ids" {
  description = "ids of the vm nics provisoned."
  value       = module.linuxserver.network_interface_ids
}

output "network_security_group_name" {
  description = "name of the security group provisioned, empty if no security group was created."
  value       = module.linuxserver.network_security_group_name
}


#LB
output "lb_id" {
  description = "the id for the azurerm_lb resource"
  value       = module.mylb.lb_id
}

output "public_ip" {
  description = "the ip address for the azurerm_lb_public_ip resource"
  value       = module.mylb.public_ip
}

output "backend_address_pool_id" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = module.mylb.backend_address_pool_id
}

