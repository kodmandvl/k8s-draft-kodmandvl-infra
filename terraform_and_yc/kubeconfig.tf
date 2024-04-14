# For local terraform apply only (it requires yc tool):
/*
resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command     = "yc managed-kubernetes cluster  get-credentials ${yandex_kubernetes_cluster.my-k8s-cluster.id} --external"
  }

  depends_on = [
    yandex_kubernetes_cluster.my-k8s-cluster
  ]
}
*/
