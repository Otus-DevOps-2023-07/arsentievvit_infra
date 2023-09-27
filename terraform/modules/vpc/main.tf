resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_default_security_group" "securitygroup" {
  description = "description for default security group"
  network_id  = "${yandex_vpc_network.network.id}"
    labels = {
    my-label = "sg"
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web Server"
    port = 9292
    protocol = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MongoDB"
    protocol = "TCP"
    port = 27017
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      description = "HTTP"
      protocol = "TCP"
      port = 80
      v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "ANY"
    description = "Allow outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = var.v4_cidr_blocks
}
