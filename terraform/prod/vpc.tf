resource "yandex_vpc_network" "prod_network" {
  name = "reddit-prod-network"
}

resource "yandex_vpc_subnet" "prod_subnet" {
  name = "reddit-prod-subnet"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.prod_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
