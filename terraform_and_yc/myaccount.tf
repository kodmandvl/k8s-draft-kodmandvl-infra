resource "yandex_iam_service_account" "myaccount" {
  name        = local.sa_name
  description = "K8S zonal service account"
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = local.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}
