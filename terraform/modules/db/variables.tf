variable "ssh_key_file" {
  description = "Path to SSH public key file"
  type        = string
  default     = null
}

variable "db_disk_image" {
  description = "Default db disk image name"
  type        = string
  default     = "reddit-app-db"
}

variable "subnet_id" {
  description = "Default VPC subnet used"
  type        = string
  default     = null
}
variable "name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "user" {
  type = string
  default = "ubuntu"
}
