terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = local.zone
  folder_id = local.folder_id
  service_account_key_file = file("/tmp/my-admin-sa-key.json")
}
