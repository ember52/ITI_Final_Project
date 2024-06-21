# Create a Kubernetes deployment for Jenkins
resource "kubernetes_deployment" "jenkins" {
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
        service_account_name = kubernetes_service_account.jenkins.metadata[0].name
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
          port {
            container_port = 50000 # Add port 50000 for JNLP
          }
          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
          security_context {
            run_as_user = 0
          }
        }
        volume {
          name = "jenkins-home"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins_pvc.metadata[0].name
          }
        }
      }
    }
  }
  # wait_for_rollout = false
}

# Create a Kubernetes service for Jenkins
resource "kubernetes_service" "jenkins_service" {
  metadata {
    name      = "jenkins-service"
    namespace = "tools"
  }
  spec {
    selector = {
      app = kubernetes_deployment.jenkins.metadata[0].labels.app
    }
    port {
      name       = "http"
      port       = 8080
      target_port = 8080
    }
    port {
      name       = "jnlp"
      port       = 50000
      target_port = 50000
    }
    type = "NodePort"
  }
}

