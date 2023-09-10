resource "yandex_compute_instance" "db" {
  hostname = "reddit-db"
  name        = "reddit-db"
  labels  = {
    tags = "reddit-db"
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
      image_id = var.db_disk_image
      size     = "15"
      type     = "network-hdd"
    }
  }
}
