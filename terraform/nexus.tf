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
            name           = "nexus"
            container_port = 8081
          }
          port {
            name           = "docker"
            container_port = 5000
          }
          volume_mount {
            name       = "nexus-repos"
            mount_path = "/nexus"
          }
        }
        volume {
          name = "nexus-repos"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nexus_pvc.metadata[0].name
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
      name        = "nexus"
      port        = 8081
      target_port = 8081
    }
    port {
      name        = "docker"
      port        = 5000
      target_port = 5000
    }
    type = "NodePort"
  }
}

