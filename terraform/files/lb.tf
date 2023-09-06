resource "yandex_lb_target_group" "applbtgtgrp" {
  name      = "app-lb"
  region_id = "ru-central1"

  target {
    address   = yandex_compute_instance.app[0].network_interface[0].ip_address
    subnet_id = var.subnet_id
  }
  target {
    address   = yandex_compute_instance.app[1].network_interface[0].ip_address
    subnet_id = var.subnet_id
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  listener {
    name = "lb-listener"
    port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.applbtgtgrp.id

    healthcheck {
      name                = "http"
      interval            = 3
      timeout             = 2
      unhealthy_threshold = 3
      healthy_threshold   = 2
      http_options {
        port = 9292
      }
    }
  }
}
