variable "yc_ssh_username" {
  type    = string
  default = null
}

variable "yc_service_account_key_file" {
  type    = string
  default = null
}

variable "yc_subnet_id" {
  type    = string
  default = null
}

variable "yc_folder_id" {
  type    = string
  default = null
}

source "yandex" "reddit-full" {
    service_account_key_file  = "${var.yc_service_account_key_file}"
    folder_id                 = "${var.yc_folder_id}"
    source_image_family       = "ubuntu-1604-lts"
    image_name                = "reddit-full-${formatdate("DD-MM-YYYY-HH-MM", timestamp())}"
    image_family              = "reddit-full"
    ssh_username              = "${var.yc_ssh_username}"
    use_ipv4_nat              = "true"
    platform_id               = "standard-v1"
    subnet_id                 = "${var.yc_subnet_id}"
    disk_type                 = "network-hdd"
    disk_size_gb              = "10"
}

build {
    sources = ["source.yandex.reddit-full"]

    provisioner "file" {
    name = "Copy Systemd service"
    source = "./files/puma.service"
    destination = "/tmp/puma.service"
    }


    provisioner "shell" {
    name            = "Install dependencies and build"
    script          = "./files/install.sh"
    execute_command = "sudo {{.Path}}"
    pause_before = "5s"
    }

    provisioner "shell" {
    name = "Start service"
    inline =    [
        "sudo cp /tmp/puma.service /etc/systemd/system/puma.service",
        "sudo systemctl enable puma.service"
        ]
    pause_before = "5s"
    }
}
