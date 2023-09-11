variable "cloud_id" {
  description = "ID of Yandex Cloud"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "ID of a folder inside Yandex Cloud accound"
  type        = string
  default     = null
}

variable "service_account_key_file" {
  description = "Path to account key of service user"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Default VPC subnet used"
  type        = string
  default     = null
}

variable "zone" {
  description = "Default zone used inside folder"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_key_file" {
  description = "Path to SSH pubkey that is transferred to VM via cloud-init metadata"
  type        = string
  default     = null
}

variable "ssh_key_private_file" {
  description = "Path to SSH private key used for connection to VM for provisioning"
  type        = string
  default     = null
}

variable "db_disk_image" {
  type    = string
  default = "db_disk_image"
}

variable "app_disk_image" {
  type    = string
  default = "app_disk_image"
}

variable "app_name" {
  type    = string
  default = "reddit-app-stage"
}

variable "db_name" {
  type    = string
  default = "reddit-db-stage"
}
