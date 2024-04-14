resource "yandex_kubernetes_node_group" "my-k8s-node-group" {
  cluster_id  = yandex_kubernetes_cluster.my-k8s-cluster.id
  name        = "default-pool"
  description = "Default node group"
  version     = local.k8s_version

  node_labels = {
    pool = "my-k8s-node-group"
  }

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.mysubnet.id]
    }

    resources {
      memory = 8
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 4
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "02:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "sunday"
      start_time = "02:00"
      duration   = "3h"
    }
  }
}
