


locals {
  k8s_nodes = {
    "k8s-cp-1"     = { ip = "10.10.1.150/16", gw = "10.10.1.1", cores = 4, memory = 4096 }
    "k8s-worker-1" = { ip = "10.10.1.151/16", gw = "10.10.1.1", cores = 2, memory = 2048 }
    "k8s-worker-2" = { ip = "10.10.1.152/16", gw = "10.10.1.1", cores = 2, memory = 2048 }
  }
}


resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  for_each  = local.k8s_nodes
  node_name = "pve2"
  name      = each.key

  clone {
    vm_id = 9003
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "nvmePCI_ZFS"
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
  initialization {
    upgrade      = false
    datastore_id = "nvmePCI_ZFS"
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = each.value.gw
      }
    }
    user_account {
      username = "deploy"
      keys     = [var.vm_sshkey]
    }
  }
}


output "k8s_vm_ids" {
  value = { for name, vm in proxmox_virtual_environment_vm.k8s_nodes : name => vm.vm_id }
}

resource "terraform_data" "known_hosts_cleanup" {
  for_each         = local.k8s_nodes
  input            = split("/", each.value.ip)[0]
  triggers_replace = [proxmox_virtual_environment_vm.k8s_nodes[each.key].id]

  provisioner "local-exec" {
    when       = destroy
    command    = "ssh-keygen -f ~/.ssh/known_hosts -R ${self.input}"
    on_failure = continue
  }
}
