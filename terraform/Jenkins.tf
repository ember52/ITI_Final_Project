# Create a Kubernetes deployment for Jenkins with Docker-in-Docker
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
        container {
          # Jenkins container
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
          env {
            name  = "DOCKER_HOST"
            value = "tcp://localhost:2375"
          }
          volume_mount {
            name       = "docker-certs"
            mount_path = "/certs/client"
            read_only  = true
          }
          volume_mount {
            name       = "docker-graph-storage"
            mount_path = "/var/lib/docker"
          }
        }
        container {
          # Docker-in-Docker container
          name  = "docker"
          image = "docker:20.10.7-dind"
          security_context {
            privileged = true
          }
          port {
            container_port = 2375
          }
          volume_mount {
            name       = "docker-certs"
            mount_path = "/certs/client"
          }
          volume_mount {
            name       = "docker-graph-storage"
            mount_path = "/var/lib/docker"
          }
        }
        volume {
          name = "docker-certs"
          empty_dir {}
        }
        volume {
          name = "docker-graph-storage"
          empty_dir {}
        }
      }
    }
  }
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
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}
