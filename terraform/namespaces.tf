

resource "kubernetes_namespace" "tools" {
  metadata {

    labels = {
      team = "development"
    }

    name = "tools"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {

    labels = {
      team = "development"
    }

    name = "dev"
  }
}