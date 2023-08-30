
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.95.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "app" {

  name        = "reddit-app"
  platform_id = "standard-v1"
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_file)}"
  }
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  network_interface {
    nat       = true
    subnet_id = var.subnet_id
    zone      = var.zone
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = "15"
      type     = "network-hdd"
    }
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
    agent       = false
    private_key = file(var.ssh_key_private_file)
  }
}
