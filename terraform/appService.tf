# Creating a nodeport service to expose the app when deployed
resource "kubernetes_service" "app-service" {
  metadata {
    name      = "app-service"
    namespace = "dev"
  }

  spec {
    type = "NodePort"

    selector = {
      app = "nodejs-app"
    }

    port {
      port        = 3000
      target_port = 3000
    }
  }
}