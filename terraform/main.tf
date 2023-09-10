provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

# data "yandex_compute_image" "db-image" {
#   family = "db"
#   folder_id = var.folder_id
# }

# data "yandex_compute_image" "app-image" {
#   folder_id = var.folder_id
#   family = "reddit-app-base"
# }

module "app" {
  source = "./modules/app"
  ssh_key_file = var.ssh_key_file
  app_image_id = var.app_disk_image
  ssh_key_private_file = var.ssh_key_private_file
  subnet_id = yandex_vpc_subnet.app_subnet.id
}

module "db" {
  source = "./modules/db"
  ssh_key_file = var.ssh_key_file
  db_disk_image = var.db_disk_image
  subnet_id = yandex_vpc_subnet.app_subnet.id
}
