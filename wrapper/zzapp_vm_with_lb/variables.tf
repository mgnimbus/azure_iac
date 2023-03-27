variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure."
  type        = string
  default     = ""
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
  type        = string
  default     = "azureuser"
}

variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Dynamic"
}

# We keep default value as `2`, not `3` as the official since this module used to hard code this argument to `2`.
variable "as_platform_fault_domain_count" {
  description = "(Optional) Specifies the number of fault domains that are used. Defaults to `2`. Changing this forces a new resource to be created."
  type        = number
  default     = 2
}

# We keep default value as `2`, not `5` as the official since this module used to hard code this argument to `2`.
variable "as_platform_update_domain_count" {
  description = "(Optional) Specifies the number of update domains that are used. Defaults to `2`. Changing this forces a new resource to be created."
  type        = number
  default     = 2
}

variable "availability_set_enabled" {
  description = "(Optional) Enable or Disable availability set.  Default is `true` (enabled)."
  type        = bool
  nullable    = false
  default     = true
}

variable "boot_diagnostics" {
  type        = bool
  description = "(Optional) Enable or Disable boot diagnostics."
  default     = false
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics."
  type        = string
  default     = "Standard_LRS"
}

variable "custom_data" {
  description = "The custom data to supply to the machine. This can be used as a cloud-init for Linux systems."
  type        = string
  default     = ""
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size."
  type        = number
  default     = 30
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type."
  type        = string
  default     = "Standard_LRS"
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

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface."
  default     = false
}

variable "enable_ssh_key" {
  type        = bool
  description = "(Optional) Enable ssh key authentication in Linux virtual Machine."
  default     = false
}

# Why use object as type? We use this variable in `count` expression, if we use a newly created `azurerm_storage_account.primary_blob_endpoint` as uri directly, then Terraform would complain that it cannot determine the value of `count` during the plan phase, so we wrap the `uri` with an object.
variable "external_boot_diagnostics_storage" {
  description = "(Optional) The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files. Set this argument would disable the creation of `azurerm_storage_account` resource."
  type = object({
    uri = string
  })
  default = null
  validation {
    condition     = var.external_boot_diagnostics_storage == null ? true : var.external_boot_diagnostics_storage.uri != null
    error_message = "`var.external_boot_diagnostics_storage.uri` cannot be `null`"
  }
}

variable "extra_disks" {
  description = "(Optional) List of extra data disks attached to each virtual machine."
  type = list(object({
    name = string
    size = number
  }))
  default = []
}

variable "extra_ssh_keys" {
  description = "Same as ssh_key, but allows for setting multiple public keys. Set your first key in ssh_key, and the extras here."
  type        = list(string)
  default     = []
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

variable "is_marketplace_image" {
  description = "Boolean flag to notify when the image comes from the marketplace."
  type        = bool
  nullable    = false
  default     = false
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}

variable "license_type" {
  description = "Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server"
  type        = string
  default     = null
}

variable "location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
  default     = null
}

variable "managed_data_disk_encryption_set_id" {
  description = "(Optional) The disk encryption set ID for the managed data disk attached using the azurerm_virtual_machine_data_disk_attachment resource."
  type        = string
  default     = null
}

variable "name_template_availability_set" {
  description = "The name template for the availability set. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-avset"
}

variable "name_template_data_disk" {
  description = "The name template for the data disks. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index', `$${data_disk_number}` => 'data disk index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-datadisk-$${host_number}-$${data_disk_number}"
}

variable "name_template_extra_disk" {
  description = "The name template for the extra disks. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index', `$${extra_disk_name}` => 'name of extra disk'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-extradisk-$${host_number}-$${extra_disk_name}"
}

variable "name_template_network_interface" {
  description = "The name template for the network interface. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-nic-$${host_number}"
}

variable "name_template_network_security_group" {
  description = "The name template for the network security group. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-nsg"
}

variable "name_template_public_ip" {
  description = "The name template for the public ip. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${ip_number}` => 'public ip index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-pip-$${ip_number}"
}

variable "name_template_vm_windows" {
  description = "The name template for the Windows virtual machine. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-vmWindows-$${host_number}"
}

variable "name_template_vm_linux" {
  description = "The name template for the Linux virtual machine. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-vmLinux-$${host_number}"
}

variable "name_template_vm_windows_os_disk" {
  description = "The name template for the Windows VM OS disk. The following replacements are automatically made: `$${vm_hostname}` => `var.vm_hostname`, `$${host_number}` => 'host index'. All other text can be set as desired."
  type        = string
  default     = "$${vm_hostname}-osdisk-$${host_number}"
}

variable "nb_data_disk" {
  description = "(Optional) Number of the data disks attached to each virtual machine."
  type        = number
  default     = 0
}

variable "nb_instances" {
  description = "Specify the number of vm instances."
  type        = number
  default     = 1
}

variable "nb_public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  type        = number
  default     = 0
}

variable "nested_data_disks" {
  description = "(Optional) When `true`, use nested data disks directly attached to the VM.  When `false`, use azurerm_virtual_machine_data_disk_attachment resource to attach the data disks after the VM is created.  Default is `true`."
  type        = bool
  nullable    = false
  default     = true
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

variable "os_profile_secrets" {
  description = "Specifies a list of certificates to be installed on the VM, each list item is a map with the keys source_vault_id, certificate_url and certificate_store."
  type        = list(map(string))
  default     = []
}

variable "public_ip_dns" {
  description = "Optional globally unique per datacenter region domain name label to apply to each public ip address. e.g. thisvar.varlocation.cloudapp.azure.com where you specify only thisvar here. This is an array of names which will pair up sequentially to the number of public ips defined in var.nb_public_ip. One name or empty string is required for every public ip. If no public ip is desired, then set this to an array with a single empty string."
  type        = list(string)
  default     = [null]
}

variable "public_ip_sku" {
  description = "Defines the SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  type        = string
  default     = "Basic"
}

variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  type        = string
  default     = ""
}

variable "source_address_prefixes" {
  description = "(Optional) List of source address prefixes allowed to access var.remote_port."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM. Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash.e.g. c : /home/id_rsa.pub."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_values" {
  description = "List of Public SSH Keys values to be used for ssh access to the VMs."
  type        = list(string)
  default     = []
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  type        = string
  default     = "Premium_LRS"
}

variable "storage_os_disk_size_gb" {
  description = "(Optional) Specifies the size of the data disk in gigabytes."
  type        = number
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

variable "vm_extension" {
  description = "(Deprecated) This variable has been superseded by the `vm_extensions`. Argument to create `azurerm_virtual_machine_extension` resource, the argument descriptions could be found at [the document](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension)."
  type = object({
    name                        = string
    publisher                   = string
    type                        = string
    type_handler_version        = string
    auto_upgrade_minor_version  = optional(bool)
    automatic_upgrade_enabled   = optional(bool)
    failure_suppression_enabled = optional(bool, false)
    settings                    = optional(string)
    protected_settings          = optional(string)
    protected_settings_from_key_vault = optional(object({
      secret_url      = string
      source_vault_id = string
    }))
  })
  default   = null
  sensitive = true # Because `protected_settings` is sensitive
}

variable "vm_extensions" {
  description = "Argument to create `azurerm_virtual_machine_extension` resource, the argument descriptions could be found at [the document](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension)."
  type = set(object({
    name                        = string
    publisher                   = string
    type                        = string
    type_handler_version        = string
    auto_upgrade_minor_version  = optional(bool)
    automatic_upgrade_enabled   = optional(bool)
    failure_suppression_enabled = optional(bool, false)
    settings                    = optional(string)
    protected_settings          = optional(string)
    protected_settings_from_key_vault = optional(object({
      secret_url      = string
      source_vault_id = string
    }))
  }))
  # tflint-ignore: terraform_sensitive_variable_no_default
  default   = []
  nullable  = false
  sensitive = true # Because `protected_settings` is sensitive
  validation {
    condition = length(var.vm_extensions) == length(distinct([
      for e in var.vm_extensions : e.type
    ]))
    error_message = "`type` in `vm_extensions` must be unique."
  }
  validation {
    condition = length(var.vm_extensions) == length(distinct([
      for e in var.vm_extensions : e.name
    ]))
    error_message = "`name` in `vm_extensions` must be unique."
  }
}

variable "vm_hostname" {
  description = "local name of the Virtual Machine."
  type        = string
  default     = "myvm"
}

variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image.Note, need to provide is_windows_image = true for windows custom images."
  type        = string
  default     = ""
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

variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
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

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_D2s_v3"
}

# Why we use `zone` not `zones` as `azurerm_virtual_machine.zones`?
# `azurerm_virtual_machine.zones` is [a list of single Az](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#zones), the maximum length is `1`
# so we can only pass one zone per vm instance.
# Why don't we use [`element`](https://developer.hashicorp.com/terraform/language/functions/element) function?
# The `element` function act as mod operator, it will iterate the vm instances, meanwhile
# we must keep the vm and public ip in the same zone.
# The vm's count is controlled by `var.nb_instances` and public ips' count is controled by `var.nb_public_ip`,
# it would be hard for us to keep the vm and public ip in the same zone once `var.nb_instances` doesn't equal to `var.nb_public_ip`
# So, we decide that one module instance supports one zone only to avoid this dilemma.
variable "zone" {
  description = "(Optional) The Availability Zone which the Virtual Machine should be allocated in, only one zone would be accepted. If set then this module won't create `azurerm_availability_set` resource. Changing this forces a new resource to be created."
  type        = string
  default     = null
}


#lb
variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

variable "type" {
  description = "(Optional) Defined if the loadbalancer is private or public"
  type        = string
  default     = "public"
}

# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the load balancer resources will be imported."
#   type        = string
# }

variable "allocation_method_lb" {
  description = "(Required) Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Static"
}

variable "disable_outbound_snat" {
  description = "(Optional) Is snat enabled for this Load Balancer Rule? Default `false`."
  type        = bool
  default     = false
}

variable "edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Changing this forces new resources to be created."
  default     = null
}

variable "frontend_name" {
  description = "(Required) Specifies the name of the frontend ip configuration."
  type        = string
  default     = "myPublicIP"
}

variable "frontend_private_ip_address" {
  description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
  type        = string
  default     = ""
}

variable "frontend_private_ip_address_allocation" {
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
  type        = string
  default     = "Dynamic"
}

variable "frontend_private_ip_address_version" {
  description = "(Optional) The version of IP that the Private IP Address is. Possible values are `IPv4` or `IPv6`."
  type        = string
  default     = null
}

variable "frontend_subnet_id" {
  description = "(Optional) Frontend subnet id to use when in private mode"
  type        = string
  default     = ""
}

variable "frontend_subnet_name" {
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
  type        = string
  default     = ""
}

variable "frontend_vnet_name" {
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
  type        = string
  default     = ""
}

variable "lb_floating_ip_enabled" {
  description = "(Optional) Are the Floating IPs enabled for this Load Balancer Rule? A floating IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to `false`."
  type        = bool
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

variable "lb_probe_interval" {
  description = "Interval in seconds the load balancer health probe rule does a check"
  type        = number
  default     = 5
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  type        = number
  default     = 2
}

variable "lb_sku" {
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "lb_sku_tier" {
  description = "(Optional) The SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Changing this forces a new resource to be created."
  type        = string
  default     = "Regional"
}

# variable "location" {
#   description = "(Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
#   type        = string
#   default     = ""
# }

variable "name" {
  description = "(Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored."
  type        = string
  default     = ""
}

variable "pip_ddos_protection_mode" {
  type        = string
  description = "(Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`."
  default     = "VirtualNetworkInherited"
}

variable "pip_ddos_protection_plan_id" {
  type        = string
  description = "(Optional) The ID of DDoS protection plan associated with the public IP. `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`."
  default     = null
}

variable "pip_domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN.  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}

variable "pip_idle_timeout_in_minutes" {
  type        = number
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to `4`."
  default     = 4
}

variable "pip_ip_tags" {
  type        = map(string)
  description = "(Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created. IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set."
  default     = null
}

variable "pip_ip_version" {
  type        = string
  description = "(Optional) The IP Version to use, `IPv6` or `IPv4`. Defaults to `IPv4`. Changing this forces a new resource to be created. Only `static` IP address allocation is supported for `IPv6`."
  default     = "IPv4"
}

variable "pip_name" {
  description = "(Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored."
  type        = string
  default     = ""
}

variable "pip_public_ip_prefix_id" {
  type        = string
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created."
  default     = null
}

variable "pip_reverse_fqdn" {
  type        = string
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
  default     = null
}

variable "pip_sku" {
  description = "(Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "pip_sku_tier" {
  type        = string
  description = "(Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created."
  default     = "Regional"
}

variable "pip_zones" {
  type        = list(string)
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
  default     = null
}

variable "prefix" {
  description = "(Required) Default prefix to use with your resource names."
  type        = string
  default     = "azure_lb"
}

variable "remote_port_nat" {
  description = "Protocols to be used for remote vm access. [protocol, backend_port].  Frontend port will be automatically generated starting at 50000 and in the output."
  type        = map(any)
  default     = {}
}

# variable "tags" {
#   type        = map(string)
#   description = "(Optional) A mapping of tags to assign to the resource."
#   default = {
#     source = "terraform"
#   }
# }


