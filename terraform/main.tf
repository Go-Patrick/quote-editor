module "rails" {
  source        = "./modules"
  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_password   = var.db_password
  db_username   = var.db_username
}