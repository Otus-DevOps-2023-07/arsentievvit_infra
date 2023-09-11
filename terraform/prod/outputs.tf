output "app-external-ip" {
  value = module.app.app-external-ip
}

output "db-external-ip" {
  value = module.db.db-external-ip
}
