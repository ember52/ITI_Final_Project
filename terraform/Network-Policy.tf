resource "kubernetes_network_policy" "allow_nodejs_to_mysql" {
  metadata {
    name      = "allow-nodejs-to-mysql"
    namespace = "dev"
  }
  spec {
    pod_selector {
      match_labels = {
        app = "mysql"
      }
    }
    policy_types = ["Ingress"]
    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "nodejs-app"
          }
        }
      }
      ports {
        protocol = "TCP"
        port     = 3306
      }
    }
  }
}
