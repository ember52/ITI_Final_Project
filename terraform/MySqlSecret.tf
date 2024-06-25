resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "dev"
  }
  data = {
    HOST                = var.mysql_host
    USERNAME            = var.mysql_username
    PASSWORD            = var.mysql_password
    DATABASE            = var.mysql_database
    MYSQL_ROOT_PASSWORD = var.mysql_root_password
  }
  type = "Opaque"
}
