terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.79.0"
    }
  }
}

# FIXED: Updated provider configuration for bpg/proxmox with API token
provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true
}

# FIXED: Changed from proxmox_vm_qemu to proxmox_virtual_environment_vm
resource "proxmox_virtual_environment_vm" "vm" {
  count     = var.vm_count
  vm_id     = 100 + (count.index + 1)
  name      = "k8s-master-${count.index + 1}"
  node_name = "proxmox" # di bawa datacenter

  # Clone configuration - hardcoded template VM ID
  clone {
    vm_id = 1000 # Ganti dengan ID template VM kamu
    full  = true
  }

  started = true

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm" # Change to your storage name
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0" # Change to your bridge name
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.ci_user
      password = var.ci_password
      keys     = [file(var.ci_ssh_public_key)]
    }
  }

  lifecycle {
    ignore_changes = [
      network_device,
      initialization,  
      agent,          
      disk,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "vmw" {
  count     = var.vm_count
  vm_id     = 200 + (count.index + 1)
  name      = "k8s-worker-${count.index + 1}"  # FIXED: Changed name to distinguish workers
  node_name = "proxmox" # di bawa datacenter

  # Clone configuration - hardcoded template VM ID
  clone {
    vm_id = 1000 # Ganti dengan ID template VM kamu
    full  = true
  }

  started = true

  cpu {
    cores = 1  # FIXED: Reduced from 2 to 1 for hardware constraints
  }

  memory {
    dedicated = 1024  # FIXED: Reduced from 4096 to 1024 for hardware constraints
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm" # Change to your storage name
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0" # Change to your bridge name
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.ci_user
      password = var.ci_password
      keys     = [file(var.ci_ssh_private_key)]
    }
  }

  lifecycle {
    ignore_changes = [
      network_device,
      initialization,  
      agent,          
      disk,
    ]
  }
}

# FIXED: ansible inventory output
resource "local_file" "ansible_inventory" {
  filename = "inventory.ini"
  content  = <<-EOT
[masters]
${join("\n", [for vm in proxmox_virtual_environment_vm.vm : "${vm.name} ansible_host=${vm.ipv4_addresses[1][0]}"])}

[workers]
${join("\n", [for vm in proxmox_virtual_environment_vm.vmw : "${vm.name} ansible_host=${vm.ipv4_addresses[1][0]}"])}

[k8s_cluster:children]
masters
workers

[k8s_cluster:vars]
ansible_user=${var.ci_user}
ansible_ssh_private_key_file=${var.ci_ssh_private_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT

  depends_on = [
    proxmox_virtual_environment_vm.vm,
    proxmox_virtual_environment_vm.vmw
  ]
}

# FIXED: Menjalankan Ansible playbook setelah inventory selesai dibuat
resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "sleep 180; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini node-exporter.yml -u ${var.ci_user} --private-key=${var.ci_ssh_private_key}"
  }

  depends_on = [
    local_file.ansible_inventory  # Ganti dari null_resource.create_ansible_inventory
  ]
}

# FIXED: Updated output configuration
output "vm_info" {
  value = {
    masters = [
      for vm in proxmox_virtual_environment_vm.vm : {
        id       = vm.vm_id
        hostname = vm.name
        ip_addr  = vm.ipv4_addresses[1][0]
      }
    ]
    workers = [
      for vm in proxmox_virtual_environment_vm.vmw : {
        id       = vm.vm_id
        hostname = vm.name
        ip_addr  = vm.ipv4_addresses[1][0]
      }
    ]
    summary = {
      total_vms = length(proxmox_virtual_environment_vm.vm) + length(proxmox_virtual_environment_vm.vmw)
      masters_count = length(proxmox_virtual_environment_vm.vm)
      workers_count = length(proxmox_virtual_environment_vm.vmw)
      total_memory_allocated = (length(proxmox_virtual_environment_vm.vm) * 1024) + (length(proxmox_virtual_environment_vm.vmw) * 1024)
    }
  }
}

# terraform apply -auto-approve