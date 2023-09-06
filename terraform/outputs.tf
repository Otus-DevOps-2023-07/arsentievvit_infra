output "app-internal-ip" {
  value = yandex_compute_instance.app.network_interface[0].ip_address
}

output "bastion-host-ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}
