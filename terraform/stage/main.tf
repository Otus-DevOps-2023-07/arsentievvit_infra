provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "network" {
  source         = "../modules/vpc"
  subnet_name    = "stage-subnet"
  network_name   = "stage-network"
  v4_cidr_blocks = ["192.168.11.0/24"]
}

module "app" {
  source               = "../modules/app"
  name                 = var.app_name
  hostname             = var.app_name
  ssh_key_file         = var.ssh_key_file
  app_image_id         = var.app_disk_image
  ssh_key_private_file = var.ssh_key_private_file
  subnet_id            = module.network.subnet_id
  database_url         = module.db.db-external-ip
}

module "db" {
  source        = "../modules/db"
  name          = var.db_name
  hostname      = var.db_name
  ssh_key_file  = var.ssh_key_file
  db_disk_image = var.db_disk_image
  subnet_id     = module.network.subnet_id
}
