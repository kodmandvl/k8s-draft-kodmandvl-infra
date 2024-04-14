resource "yandex_kubernetes_cluster" "my-k8s-cluster" {
  name = "my-k8s-cluster"
  network_id = yandex_vpc_network.mynet.id
  master {
    version = local.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.mysubnet.zone
      subnet_id = yandex_vpc_subnet.mysubnet.id
    }

    public_ip = true

    security_group_ids = [
      yandex_vpc_security_group.k8s-public-services.id,
      yandex_vpc_security_group.k8s-master-whitelist.id,
      yandex_vpc_security_group.k8s-nodes-ssh-access.id
    ]
  }
  service_account_id      = yandex_iam_service_account.myaccount.id
  node_service_account_id = yandex_iam_service_account.myaccount.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.admin
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
  release_channel = "STABLE"
}
