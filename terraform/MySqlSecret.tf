resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "dev"
  }
  data = {
    HOST     = base64encode(var.mysql_host)
    USERNAME = base64encode(var.mysql_username)
    PASSWORD = base64encode(var.mysql_password)
    DATABASE = base64encode(var.mysql_database)
  }
  type = "Opaque"
}
