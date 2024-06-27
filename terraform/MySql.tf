# # Create a Kubernetes deployment for MySql
resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name      = "mysql"
    namespace = "dev"
  }
  spec {
    service_name = "mysql"
    replicas     = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }
          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "DATABASE"
              }
            }
          }
          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "USERNAME"
              }
            }
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "PASSWORD"
              }
            }
          }
          env {
            name = "MYSQL_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "HOST"
              }
            }
          }
          port {
            container_port = 3306
          }
          volume_mount {
            name       = "mysql-pvc"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "mysql-pvc"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
        volume_name = kubernetes_persistent_volume.mysql_pv.metadata[0].name # Links to the PV
      }
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = "dev"
  }
  spec {
    cluster_ip = "None"
    selector = {
      app = "mysql"
    }
    port {
      port        = 3306
      target_port = 3306
    }
  }
}
