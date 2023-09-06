output "app-internal-ip" {
  value = yandex_compute_instance.app[0].network_interface[0].ip_address
}
