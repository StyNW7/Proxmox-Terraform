# terraform.tfvars - Terraform Variables Values

# Proxmox API Configuration for Load Balancer (192.168.2.10)
proxmox_lb_api_url = "https://192.168.2.10:8006/api2/json"
proxmox_lb_api_token_id = "root@pam!ansi-lb"
proxmox_lb_api_token_secret = "10889e22-8806-4298-97eb-ed22f8d4ca84"

# Proxmox API Configuration for Worker Nodes (192.168.2.11)
proxmox_worker_api_url = "https://192.168.2.11:8006/api2/json"
proxmox_worker_api_token_id = "root@pam!ansi-work"
proxmox_worker_api_token_secret = "178dcd5f-6b74-4428-92af-0ccb177063c4"

# Cloud-init Configuration
ci_user = "root"
ci_password = "Group3"
ci_ssh_public_key = "~/.ssh/id_rsa.pub"
ci_ssh_private_key = "~/.ssh/id_rsa"

# VM Configuration
lb_vm_count = 1
worker_vm_count = 3

# VM Specifications
vm_memory = 2048
vm_cores = 2
vm_disk_size = "20G"
vm_template = "ubuntu-cloud-template"
vm_storage = "local-lvm"
network_bridge = "vmbr0"