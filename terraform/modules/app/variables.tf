variable "app_image_id" {
  description = "Default image for reddit-app"
  default     = "reddit-app-ansible"
}

variable "ssh_key_file" {
  description = "Path to SSH pubkey that is transferred to VM via cloud-init metadata"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Default VPC subnet used"
  type        = string
  default     = null
}

variable "ssh_key_private_file" {
  description = "SSH private key that is transferred to APP instance"
  type        = string
  default     = null
}

variable "name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "database_url" {
  type = string
}

variable "user" {
  default = "ubuntu"
}
