variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "ci_user" {
  type = string
}

variable "ci_password" {
  type = string
  sensitive = true
}

variable "ci_ssh_public_key" {
  type = string
}

variable "ci_ssh_private_key" {
  type = string
}


variable "worker_count_subnet_3" {
  type = number
  default = 2
}

variable "worker_count_subnet_4" {
  type = number
  default = 1
}

variable "master_count" {
  type = number
  default = 2
}