variable "yc_service_account_key_file" {
    type = string
    description = "My service access file"
    default = null
}

variable "yc_subnet_id" {
    type = string
    description = "Virtual private network ID"
    default = null
}

variable "yc_folder_id" {
    type = string
    description = "Default folder in which operation go"
    default = null

}

variable "yc_ssh_username" {
    type = string
    description = "Default SSH username"
    default = "ubuntu"
}



source "yandex" "db" {
  service_account_key_file  = "${var.yc_service_account_key_file}"
  folder_id                 = "${var.yc_folder_id}"
  source_image_family       = "ubuntu-1604-lts"
  image_name                = "db-${formatdate("DD-MM-YYYY-HH-MM", timestamp())}"
  image_family              = "db"
  ssh_username              = "${var.yc_ssh_username}"
  use_ipv4_nat              = "true"
  platform_id               = "standard-v1"
  subnet_id                 = "${var.yc_subnet_id}"
  disk_type                 = "network-hdd"
  disk_size_gb              = "15"
}

build {
  sources = ["source.yandex.db"]

  provisioner "shell" {
    name            = "mongodb"
    script          = "./scripts/install_mongodb.sh"
    execute_command = "sudo {{.Path}}"
  }
}
