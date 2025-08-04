# variables.tf - Terraform Variables Definition

# Proxmox API Configuration
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API Token Secret"
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
variable "master_count" {
  description = "Number of master VMs to create"
  type        = number
  default     = 2
}

variable "worker_count" {
  description = "Number of worker VMs to create"
  type        = number
  default     = 3
}

# Memory Alloc
variable "master_memory {
  description = "Memory for master nodes in MB"
  type        = number
  default     = 4096 # 4 GB
}

variable "worker_memory" {
  description = "Memory for worker nodes in MB"
  type        = number
  default     = 3072 # 3 GB
}