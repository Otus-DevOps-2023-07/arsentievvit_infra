output "vm1-external-ip" {
  value = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
}

output "vm1-internal-ip" {
  value = yandex_compute_instance.vm-1.network_interface[0].ip_address
}
