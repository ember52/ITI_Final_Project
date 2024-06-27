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
        init_container {
          name    = "init-permissions"
          image   = "busybox"
          command = ["sh", "-c", "chown -R 200 /nexus-data"]
          volume_mount {
            name       = "nexus-repos"
            mount_path = "/nexus-data"
          }
        }
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
            mount_path = "/nexus-data"
          }
          security_context {
            run_as_user = 200
          }
        }
        security_context {
          fs_group = 200
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
      node_port   = 30003
    }
    port {
      name        = "docker"
      port        = 5000
      target_port = 5000
      node_port   = 30004
    }
    type = "NodePort"
  }
}

