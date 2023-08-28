variable "yc_service_account_key_file" {
    type = string
    description = "My service access file"
    default = env("YC_SERVICE_ACCOUNT_KEY_FILE")
}

variable "yc_subnet_id" {
    type = string
    description = "Virtual private network ID"
    default = env("YC_VPC_ID")
}

variable "yc_folder_id" {
    type = string
    description = "Default folder in which operation go"
    default = env("YC_FOLDER_ID")
}

variable "yc_ssh_username" {
    type = string
    description = "Default SSH username"
    default = "ubuntu"
}


source "yandex" "ubuntu16" {
  service_account_key_file  = "${var.yc_service_account_key_file}"
  folder_id                 = "${var.yc_folder_id}"
  source_image_family       = "ubuntu-1604-lts"
  image_name                = "reddit-base-${formatdate("DD-MM-YYYY-HH-MM", timestamp())}"
  image_family              = "reddit-base"
  ssh_username              = "${var.yc_ssh_username}"
  use_ipv4_nat              = "true"
  platform_id               = "standard-v1"
  subnet_id                 = "${var.yc_subnet_id}"
  disk_type                 = "network-hdd"
  disk_size_gb              = "10"
}

build {
  sources = ["source.yandex.ubuntu16"]

  provisioner "shell" {
    name            = "ruby"
    script          = "./scripts/install_ruby.sh"
    execute_command = "sudo {{.Path}}"
  }

  provisioner "shell" {
    name            = "mongodb"
    script          = "./scripts/install_mongodb.sh"
    execute_command = "sudo {{.Path}}"
  }
}
