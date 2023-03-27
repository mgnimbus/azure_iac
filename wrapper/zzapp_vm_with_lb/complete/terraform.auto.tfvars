
vm_os_publisher = "RedHat"
vm_os_offer     = "RHEL"
vm_os_sku       = "86-gen2"
vm_os_version   = "latest"

delete_data_disks_on_termination = true
delete_os_disk_on_termination    = true

lb_port = {
  http = ["80", "Tcp", "80"]
}
lb_probe = {
  http = ["Tcp", "80", ""]
}
