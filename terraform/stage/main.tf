provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source = "../modules/app"
  name = "reddit-app-stage"
  hostname = "reddit-app-stage"
  ssh_key_file = var.ssh_key_file
  app_image_id = var.app_disk_image
  ssh_key_private_file = var.ssh_key_private_file
  subnet_id = yandex_vpc_subnet.stage_subnet.id
}

module "db" {
  source = "../modules/db"
  name = "reddit-db-stage"
  hostname = "reddit-db-stage"
  ssh_key_file = var.ssh_key_file
  db_disk_image = var.db_disk_image
  subnet_id = yandex_vpc_subnet.stage_subnet.id
}
