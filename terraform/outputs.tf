output "vm1-external-ip" {
  value = yandex_compute_instance.app.network_interface[0].nat_ip_address
}
