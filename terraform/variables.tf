variable "proxmox_url" {
  type        = string
  description = "Proxmox API URL, supplied via TF_VAR_proxmox_url."
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Proxmox API token secret, supplied via TF_VAR_proxmox_api_token_secret."
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID, supplied via TF_VAR_proxmox_api_token_id."
}
