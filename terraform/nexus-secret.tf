resource "kubernetes_secret" "kaniko_secret" {
  metadata {
    name      = "kaniko-secret"
    namespace = "tools"
  }

  data = {
    "config.json" = jsonencode({
      auths = {
        "nexus-service.tools.svc:5000" = {
          username = var.nexus_username
          password = var.nexus_password
        }
      }
    })
  }

  type = "Opaque"
}