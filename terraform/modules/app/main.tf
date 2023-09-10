resource "yandex_compute_instance" "app" {
  hostname = "reddit-app"
  name        = "reddit-app-base"
  labels  = {
    tags = "reddit-app"
  }
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
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = var.app_image_id
      size     = "15"
      type     = "network-hdd"
    }
  }
}
