resource "kubernetes_secret" "app-secret" {
  metadata {
    name      = "app-secret"
    namespace = "dev"
  }
  data = {
    HOST     = "mysql-service"
    USERNAME = "cloud44"
    PASSWORD = 1234
    DATABASE = "db_final"
  }
}