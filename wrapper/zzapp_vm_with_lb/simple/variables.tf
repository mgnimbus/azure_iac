variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "The location in which the resources will be created."
  type        = string
  default     = null
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
  type        = string
  default     = "azureuser"
}

variable "enable_ssh_key" {
  type        = bool
  description = "(Optional) Enable ssh key authentication in Linux virtual Machine."
  default     = false
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Delete data disks when machine is terminated."
  default     = false
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete OS disk when machine is terminated."
  default     = false
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = "latest"
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Delete data disks when machine is terminated."
  default     = false
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete OS disk when machine is terminated."
  default     = false
}

variable "lb_port" {
  description = "Protocols to be used for lb rules. Format as [frontend_port, protocol, backend_port]"
  type        = map(any)
  default     = {}
}

variable "lb_probe" {
  description = "(Optional) Protocols to be used for lb health probes. Format as [protocol, port, request_path]"
  type        = map(any)
  default     = {}
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure."
  type        = string
  default     = ""
}

variable "network_security_group" {
  description = "The network security group we'd like to bind with virtual machine. Set this variable will disable the creation of `azurerm_network_security_group` and `azurerm_network_security_rule` resources."
  type = object({
    id = string
  })
  default = null
  validation {
    condition     = var.network_security_group == null ? true : var.network_security_group.id != null
    error_message = "When `var.network_security_group` is not `null`, `var.network_security_group.id` is required."
  }
}

variable "name" {
  description = "(Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored."
  type        = string
  default     = ""
}

variable "lb_sku" {
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "frontend_private_ip_address_allocation" {
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
  type        = string
  default     = "Dynamic"
}

