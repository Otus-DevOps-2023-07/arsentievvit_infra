output "db-external-ip" {
  value = yandex_compute_instance.db.network_interface[0].nat_ip_address
}
