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

source "yandex" "reddit-app-base" {
    service_account_key_file  = "${var.yc_service_account_key_file}"
    folder_id                 = "${var.yc_folder_id}"
    source_image_family       = "ubuntu-1604-lts"
    image_name                = "reddit-app-base-${formatdate("DD-MM-YYYY-HH-MM", timestamp())}"
    image_family              = "reddit-app-base"
    ssh_username              = "${var.yc_ssh_username}"
    use_ipv4_nat              = "true"
    platform_id               = "standard-v1"
    subnet_id                 = "${var.yc_subnet_id}"
    disk_type                 = "network-hdd"
    disk_size_gb              = "10"
}

build {
    sources = ["source.yandex.reddit-app-base"]

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
