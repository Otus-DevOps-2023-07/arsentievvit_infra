resource "yandex_vpc_network" "stage_network" {
  name = "reddit-stage-network"
}

resource "yandex_vpc_subnet" "stage_subnet" {
  name = "reddit-stage-subnet"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.stage_network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}
