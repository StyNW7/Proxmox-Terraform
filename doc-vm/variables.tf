# variables.tf - Terraform Variables Definition

# Proxmox API Configuration for Load Balancer
variable "proxmox_lb_api_url" {
  description = "Proxmox API URL for Load Balancer"
  type        = string
}

variable "proxmox_lb_api_token_id" {
  description = "Proxmox API Token ID for Load Balancer"
  type        = string
}

variable "proxmox_lb_api_token_secret" {
  description = "Proxmox API Token Secret for Load Balancer"
  type        = string
  sensitive   = true
}

# Proxmox API Configuration for Worker Nodes
variable "proxmox_worker_api_url" {
  description = "Proxmox API URL for Worker Nodes"
  type        = string
}

variable "proxmox_worker_api_token_id" {
  description = "Proxmox API Token ID for Worker Nodes"
  type        = string
}

variable "proxmox_worker_api_token_secret" {
  description = "Proxmox API Token Secret for Worker Nodes"
  type        = string
  sensitive   = true
}

# Cloud-init Configuration
variable "ci_user" {
  description = "Cloud-init default username"
  type        = string
}

variable "ci_password" {
  description = "Cloud-init default password"
  type        = string
  sensitive   = true
}

variable "ci_ssh_public_key" {
  description = "Path to SSH public key file for cloud-init"
  type        = string
}

variable "ci_ssh_private_key" {
  description = "Path to SSH private key file"
  type        = string
  sensitive   = true
}

# VM Configuration
variable "lb_vm_count" {
  description = "Number of Load Balancer VMs to create"
  type        = number
  default     = 1
}

variable "worker_vm_count" {
  description = "Number of Worker VMs to create"
  type        = number
  default     = 3
}

# VM Specifications
variable "vm_memory" {
  description = "Memory allocation for VMs in MB"
  type        = number
  default     = 2048
}

variable "vm_cores" {
  description = "Number of CPU cores for VMs"
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Disk size for VMs"
  type        = string
  default     = "20G"
}

variable "vm_template" {
  description = "Template name to use for VM creation"
  type        = string
  default     = "ubuntu-cloud-template"
}

variable "vm_storage" {
  description = "Storage pool name"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}