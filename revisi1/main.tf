terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}


provider "proxmox" {
  # Configuration options
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true #karena ssl nya masi blm sedcure (http)
}



resource "proxmox_vm_qemu" "k8s-master" {
    # ip 192.168.2.50
  name        = "k8s-master"
  target_node = "proxmox"
  vmid       = 300
  clone      = "ubuntu-template"
  full_clone = true
  count = var.master_count

  ciuser    = var.ci_user
  cipassword = var.ci_password
  sshkeys   = file(var.ci_ssh_public_key)

  agent     = 1
  cores     = 2
  memory    = 4096
  os_type   = "cloud-init"
  bootdisk  = "scsi0"
  scsihw    = "virtio-scsi-pci"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 20
          storage = "local"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot     = "order=scsi0"
  ipconfig0 = "ip=192.168.2.${count.index + 50}/24,gw=192.168.2.1" #gatewaynya ip proxmox
  # ipconfig0 = "ip=dhcp"
  
  lifecycle {
    ignore_changes = [ 
      network
    ]
  }
}

resource "proxmox_vm_qemu" "k8s-workers-subnet-3" {
  count       = var.worker_count_subnet_3
  name        = "k8s-worker-subnet3-${count.index + 1}"
  target_node = "peoxmox"
  vmid        = 301 + count.index
  clone       = "ubuntu-template"
  full_clone  = true

  ciuser    = var.ci_user
  cipassword = var.ci_password
  sshkeys   = file(var.ci_ssh_public_key)

  agent     = 1
  cores     = 2
  memory    = 4096
  os_type   = "cloud-init"
  bootdisk  = "scsi0"
  scsihw    = "virtio-scsi-pci"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 10
          storage = "local"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot     = "order=scsi0"
  ipconfig0 = "ip=192.168.3.${count.index + 50}/24,gw=192.168.3.1"
  # ipconfig0 = "ip=dhcp"
  
  lifecycle {
    ignore_changes = [ 
      network
    ]
  }
}

resource "proxmox_vm_qemu" "k8s-workers-subnet-4" {
  count       = var.worker_count_subnet_4
  name        = "k8s-worker-subnet4-${count.index + 1}"
  target_node = "proxwrlb"
  vmid        = 401 + count.index
  clone       = "ubuntu-template"
  full_clone  = true

  ciuser    = var.ci_user
  cipassword = var.ci_password
  sshkeys   = file(var.ci_ssh_public_key)

  agent     = 1
  cores     = 2
  memory    = 4096
  os_type   = "cloud-init"
  bootdisk  = "scsi0"
  scsihw    = "virtio-scsi-pci"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 10
          storage = "local"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot     = "order=scsi0"
  ipconfig0 = "ip=192.168.4.${count.index + 50}/24,gw=192.168.4.1"
  # ipconfig0 = "ip=dhcp"
  
  lifecycle {
    ignore_changes = [ 
      network
    ]
  }
}

output "vm_info" {
  value = {
    master = [
      for vm in proxmox_vm_qemu.k8s-master : {
        hostname = vm.name
        ip_addr  = vm.default_ipv4_address
      }
    ],
    workers-subnet3 = [
      for vm in proxmox_vm_qemu.k8s-workers-subnet-3 : {
        hostname = vm.name
        ip_addr  = vm.default_ipv4_address
      }
    ],
    workers-subnet4 = [
      for vm in proxmox_vm_qemu.k8s-workers-subnet-4 : {
        hostname = vm.name
        ip_addr  = vm.default_ipv4_address
      }
    ],
  }
}

# setelah kelar provisioning, simpen ip addressnya di dlm inventory
resource "local_file" "create_ansible_inventory" {
  depends_on = [
    proxmox_vm_qemu.k8s-master,
    proxmox_vm_qemu.k8s-workers-subnet-3,
    proxmox_vm_qemu.k8s-workers-subnet-4
  ]

  content = <<EOT
[master-node]
${join("\n", [for master in proxmox_vm_qemu.k8s-master : master.default_ipv4_address])}
[worker-node-subnet3]
${join("\n", [for worker in proxmox_vm_qemu.k8s-workers-subnet-3 : worker.default_ipv4_address])}
[worker-node-subnet4]
${join("\n", [for worker in proxmox_vm_qemu.k8s-workers-subnet-4 : worker.default_ipv4_address])}

EOT

  filename = "./inventory.ini"
}

resource "null_resource" "testing_ansible" {
  depends_on = [ local_file.create_ansible_inventory ]
  provisioner "local-exec" {
    command = "sleep 180;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.ini init.yml -u ${var.ci_user} --private-key=${var.ci_ssh_private_key}"
  }
}

# resource "null_resource" "install_software" {
#   depends_on = [ local_file.create_ansible_inventory ]
#   provisioner "local-exec" {
#     command = "sleep 180;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.ini playbook-install-software.yml -u ${var.ci_user} --private-key=${var.ci_ssh_private_key}"
#   }
# }


# resource "null_resource" "ansible_playbook" {
#     depends_on = [null_resource.testing_ansible]
#     provisioner "local-exec" {
#         command = "sleep 180;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.ini playbook-create-k8s-cluster.yml -u ${var.ci_user} --private-key=${var.ci_ssh_private_key}"
#     }
# }


