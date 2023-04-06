## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.49.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm_lb_int"></a> [vm\_lb\_int](#module\_vm\_lb\_int) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface_backend_address_pool_association.web_nic_lb_associate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure. | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The admin username of the VM that will be deployed. | `string` | `"azureuser"` | no |
| <a name="input_delete_data_disks_on_termination"></a> [delete\_data\_disks\_on\_termination](#input\_delete\_data\_disks\_on\_termination) | Delete data disks when machine is terminated. | `bool` | `false` | no |
| <a name="input_delete_os_disk_on_termination"></a> [delete\_os\_disk\_on\_termination](#input\_delete\_os\_disk\_on\_termination) | Delete OS disk when machine is terminated. | `bool` | `false` | no |
| <a name="input_enable_ssh_key"></a> [enable\_ssh\_key](#input\_enable\_ssh\_key) | (Optional) Enable ssh key authentication in Linux virtual Machine. | `bool` | `false` | no |
| <a name="input_frontend_private_ip_address_allocation"></a> [frontend\_private\_ip\_address\_allocation](#input\_frontend\_private\_ip\_address\_allocation) | (Optional) Frontend ip allocation type (Static or Dynamic) | `string` | `"Dynamic"` | no |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | Protocols to be used for lb rules. Format as [frontend\_port, protocol, backend\_port] | `map(any)` | `{}` | no |
| <a name="input_lb_probe"></a> [lb\_probe](#input\_lb\_probe) | (Optional) Protocols to be used for lb health probes. Format as [protocol, port, request\_path] | `map(any)` | `{}` | no |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku) | (Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. | `string` | `"Basic"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location in which the resources will be created. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored. | `string` | `""` | no |
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | The network security group we'd like to bind with virtual machine. Set this variable will disable the creation of `azurerm_network_security_group` and `azurerm_network_security_rule` resources. | <pre>object({<br>    id = string<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the resources will be created. | `string` | n/a | yes |
| <a name="input_vm_os_offer"></a> [vm\_os\_offer](#input\_vm\_os\_offer) | The name of the offer of the image that you want to deploy. This is ignored when vm\_os\_id or vm\_os\_simple are provided. | `string` | `""` | no |
| <a name="input_vm_os_publisher"></a> [vm\_os\_publisher](#input\_vm\_os\_publisher) | The name of the publisher of the image that you want to deploy. This is ignored when vm\_os\_id or vm\_os\_simple are provided. | `string` | `""` | no |
| <a name="input_vm_os_sku"></a> [vm\_os\_sku](#input\_vm\_os\_sku) | The sku of the image that you want to deploy. This is ignored when vm\_os\_id or vm\_os\_simple are provided. | `string` | `""` | no |
| <a name="input_vm_os_version"></a> [vm\_os\_version](#input\_vm\_os\_version) | The version of the image that you want to deploy. This is ignored when vm\_os\_id or vm\_os\_simple are provided. | `string` | `"latest"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The subnet id of the virtual network where the virtual machines will reside. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#output\_frontend\_ip\_configuration) | the frontend\_ip\_configuration for the azurerm\_lb resource |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | the id for the azurerm\_lb resource |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | ids of the vm nics provisoned. |
| <a name="output_network_security_group_name"></a> [network\_security\_group\_name](#output\_network\_security\_group\_name) | name of the security group provisioned, empty if no security group was created. |
| <a name="output_vm_ids"></a> [vm\_ids](#output\_vm\_ids) | Virtual machine ids created. |
| <a name="output_vm_names"></a> [vm\_names](#output\_vm\_names) | Virtual machine names created. |
