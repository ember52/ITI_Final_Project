
# Create a Kubernetes deployment for Jenkins
resource "kubernetes_deployment" "Jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      app = "jenkins"
    }
    namespace = kubernetes_namespace.tools.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Create a Kubernetes service
resource "kubernetes_service" "Jenkins_service" {
  metadata {
    name = "jenkins-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.Jenkins.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
