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

variable "image_id" {
  description = "ID of an image that is used to create VM"
  type        = string
  default     = null
}

variable "app_image_id" {
  description = "Default image for reddit-app"
  default = "reddit-app-base"
}

variable "db_image_id" {
  description = "Default image for reddit-app-db"
  default = "db"
}
