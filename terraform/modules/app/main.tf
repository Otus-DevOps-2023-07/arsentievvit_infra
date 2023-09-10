resource "yandex_compute_instance" "app" {
  name     = var.name
  hostname = var.hostname
  labels = {
    tags = "reddit-app"
  }
  platform_id = "standard-v1"
  metadata = {
    ssh-keys = "${var.user}:${file(var.ssh_key_file)}"
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
  provisioner "file" {
    content     = templatefile("${path.module}/files/puma.service.tftpl", { database_url = var.database_url })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.ssh_key_private_file)
    host        = self.network_interface[0].nat_ip_address
    port        = 22
  }
}
