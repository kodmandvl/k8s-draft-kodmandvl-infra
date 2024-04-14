# Prepare with yc for Terraform (before Kubernetes cluster creating):

You should replace `values` with your values in this README.md and in the locals.tf file and then run these actions. Values: 

- cloud-id
- folder-id
- my.ip.ad.dr (client IP for connecting to K8s)
- my-admin-sa (service account that we create before all actions)
- my-admin-sa-id (ID of my-admin-sa)
- my-cluster-sa (this is a service account that will be created by the my-admin-sa service account already for K8s cluster management)
- and so on (by example, if you need set other k8s_version, zone, etc.)

## yc:

```bash
yc init
yc config list
```

## Service Account (my-admin-sa):

```bash
yc iam service-account create --name my-admin-sa
yc iam service-account get my-admin-sa
yc iam service-account list
```

## Role(s) for Service Account(s):

```bash
yc iam role list
yc iam service-account list
yc config list
yc resource-manager folder list-access-bindings <folder-id>
```

```bash
yc resource-manager folder add-access-binding <folder-id> --subject serviceAccount:<my-admin-sa-id> --role admin
yc resource-manager folder list-access-bindings <folder-id>
```

## Create authorized key for my-admin-sa:

```bash
yc iam key create \
  --service-account-id <my-admin-sa-id> \
  --folder-id <folder-id> \
  --output my-admin-sa-key.json
```

## Create CLI profile for my-admin-sa:

```bash
yc config profile create my-admin-sa-profile
```

## Set my-admin-sa-profile configuration:

```bash
yc config set service-account-key my-admin-sa-key.json
yc config set cloud-id <cloud-id>
yc config set folder-id <folder-id>
yc config list
```

## Set ENV variables:

```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
yc config list
echo $YC_TOKEN
echo $YC_CLOUD_ID
echo $YC_FOLDER_ID
```

# Terraform:

```bash
terraform --version
touch ./your_resource.tf
touch ./locals.tf
nano ~/.terraformrc
```

## Contents of ~/.terraformrc: 

```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

## Contents of locals.tf:

```
locals {
  cloud_id    = "<cloud-id>"
  folder_id   = "<folder-id>"
  k8s_version = "1.28"
  sa_name     = "my-cluster-sa"
  zone        = "ru-central1-a"
  allowed_ips = ["my.ip.ad.dr/32"]
}
```

## Create and edit *.tf files with describing of your resources

```bash
nano ./your_resource.tf
```

## Contents of provider.tf file, example:

```
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
  service_account_key_file = file("/path/to/your/key.json")
}
```

Ant then we describe all resources for our cluster. Example of K8s cluster is [here](https://terraform-provider.yandexcloud.net/Resources/kubernetes_cluster) and [here](https://cloud.yandex.ru/ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create#tf_1). 

## init, validate, plan, apply:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## at the end of education or after errors:

```bash
terraform destroy
```
