# Persistent Volume (PV) using hostPath
resource "kubernetes_persistent_volume" "jenkins_pv" {
  metadata {
    name = "jenkins-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"  # Replace with the name of your standard storage class
    persistent_volume_source {
      host_path {
        path = "/mnt/data"
        type = "DirectoryOrCreate"  # Kubernetes will create /mnt/data if it doesn't exist
      }
    }
  }
}


# Persistent Volume Claim (PVC)
resource "kubernetes_persistent_volume_claim" "jenkins_pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = ""  # Replace with your desired StorageClass
    # volume_name        = kubernetes_persistent_volume.jenkins_pv.metadata[0].name  # Links to the PV
  }
}

# Persistent Volume (PV) using hostPath
resource "kubernetes_persistent_volume" "nexus_pv" {
  metadata {
    name = "nexus-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"
    persistent_volume_source {
      host_path {
        path = "/mnt/nexus"
        type = "DirectoryOrCreate"
      }
    }
  }
}


# Persistent Volume Claim (PVC)
resource "kubernetes_persistent_volume_claim" "nexus_pvc" {
  metadata {
    name      = "nexus-pvc"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = ""  # Replace with your desired StorageClass
    # volume_name        = kubernetes_persistent_volume.jenkins_pv.metadata[0].name  # Links to the PV
  }
}
