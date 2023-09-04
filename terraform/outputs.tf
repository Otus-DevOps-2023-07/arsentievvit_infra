output "app-internal-ip" {
  value = yandex_compute_instance.app[0].network_interface[0].ip_address
}

output "app2-internal-ip" {
  value = yandex_compute_instance.app[1].network_interface[0].ip_address
}

output "bastion-host-ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}
