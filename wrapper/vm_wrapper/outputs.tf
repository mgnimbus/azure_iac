output "vm_ids" {
  description = "Virtual machine ids created."
  value       = module.vm-wrapper.vm_ids
}

output "vm_names" {
  description = "Virtual machine names created."
  value       = module.vm-wrapper.vm_names
}

output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value       = module.vm-wrapper.public_ip_address
}

output "public_ip_id" {
  description = "id of the public ip address provisoned."
  value       = module.vm-wrapper.public_ip_id
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = module.vm-wrapper.network_interface_private_ip
}

output "network_security_group_name" {
  description = "name of the security group provisioned, empty if no security group was created."
  value       = module.vm-wrapper.network_security_group_name
}

output "network_security_group_id" {
  description = "id of the security group provisioned"
  value       = module.vm-wrapper.network_security_group_id
}

output "public_ip_dns_name" {
  description = "fqdn to connect to the first vm provisioned."
  value       = module.vm-wrapper.public_ip_dns_name
}

output "network_interface_ids" {
  description = "ids of the vm nics provisoned."
  value       = module.vm-wrapper.network_interface_ids
}

output "availability_set_id" {
  description = "Id of the availability set where the vms are provisioned. If `var.zones` is set, this output will return empty string."
  value       = module.vm-wrapper.availability_set_id
}

output "vm_identity" {
  description = "map with key `Virtual Machine Id`, value `list of identity` created for the Virtual Machine."
  value       = module.vm-wrapper.vm_identity
}

output "vm_zones" {
  description = "map with key `Virtual Machine Id`, value `list of the Availability Zone` which the Virtual Machine should be allocated in."
  value       = module.vm-wrapper.vm_zones
}
