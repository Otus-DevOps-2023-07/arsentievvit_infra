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
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = var.v4_cidr_blocks
}
