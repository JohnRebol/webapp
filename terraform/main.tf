data "proxmox_version" "example" {}

output "data_proxmox_version" {
  value = {
    release       = data.proxmox_version.example.release
    repository_id = data.proxmox_version.example.repository_id
    version       = data.proxmox_version.example.version
  }
}

data "proxmox_virtual_environment_vms" "all" {
  filter {
    name   = "name"
    values = ["forge", "app-host"]
  }
}

locals {
  vms = data.proxmox_virtual_environment_vms.all.vms
}

output "all_vms" {
  value = [for vm in local.vms : vm if contains(["forge", "app-host"], vm.name)]
}
