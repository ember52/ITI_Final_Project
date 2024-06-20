

# Create a Kubernetes deployment for Nexus
resource "kubernetes_deployment" "nexus" {
  metadata {
    name = "nexus"
    labels = {
      app = "nexus"
    }
    namespace = kubernetes_namespace.tools.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nexus"
      }
    }
    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }
      spec {
        container {
          name  = "nexus"
          image = "sonatype/nexus3"
          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

# Create a Kubernetes service
resource "kubernetes_service" "nexus_service" {
  metadata {
    name      = "nexus-service"
    namespace = "tools"

  }
  spec {
    selector = {
      app = kubernetes_deployment.nexus.metadata[0].labels.app
    }
    port {
      port        = 8081
      target_port = 8081
    }
    type = "NodePort"
  }
}

