# Local draft (локальный черновик)

## Minikube

Для развёртывания Minikube использовал [такой скрипт-обёртку из своего репозитория](https://github.com/kodmandvl/wrapper_scripts/blob/main/minikube/minikube_start_new.sh): 

```bash
minikube_start_new.sh minikube 1.28 docker containerd 4 8192m --addons=metallb,ingress
# Что выполняется внутри скрипта:
# minikube start -p minikube --kubernetes-version=v1.28 --driver=docker --container-runtime=containerd --cpus=4 --memory=8192m --addons=metallb,ingress
```

## MetalLB Config

* Для конфигурации MetalLB также выполнялось: 

```bash
kubectl apply -f metallb-config.yaml
```

* И добавление маршрута на своей локальной машине:

```bash
route
sudo ip route add 192.168.118.0/24 via `minikube ip`
route
# для удаления маршрута в конце работ:
# sudo route -v del -net 192.168.118.0/24 gw `minikube ip`
```

## S3-хранилище для для бэкапов

* Для развёртывания MinIO в Minikube:

```bash
cd minio
kubectl apply -f minio-ns.yaml
kubectl config set-context --current --namespace=minio
kubectl config get-contexts
kubectl apply -f minio-secret.yaml -f minio-statefulset.yaml -f minio-svc-lb.yaml
kubectl exec -it pods/minio-0 env 
```

* MinIO client

https://min.io/docs/minio/linux/reference/minio-mc.html 

```bash
curl https://dl.min.io/client/mc/release/linux-amd64/mc   --create-dirs   -o $HOME/minio-binaries/mc
chmod +x $HOME/minio-binaries/mc
export PATH=$HOME/minio-binaries/:$PATH
mc --help
sudo install -o root -g root -m 0755 ~/minio-binaries/mc /usr/local/bin/minio-client
minio-client alias set myminio http://192.168.49.2:30900/ root MyMinIOSecretKey123
minio-client admin info myminio
minio-client ls myminio
minio-client ls myminio/mypgbackups/mypg/
minio-client du myminio/mypgbackups/mypg/
minio-client du myminio/mypgbackups/mypg/base/
minio-client du myminio/mypgbackups/mypg/wals/
minio-client du myminio
```

* S3 storage on Yandex Cloud

Также еще до размещения managed кластера Kubernetes в Yandex Cloud уже было опробовано резервное копирование с Minikube на S3-хранилище в Yandex Cloud: 

```bash
# my-backup-sa is service account with storage.admin role
# key for my-backup-sa:
yc iam access-key create --service-account-name my-backup-sa --description "Key for S3"
s3cmd --configure
nano ~/.s3cfg
s3cmd ls
s3cmd mb s3://mypgbackups
s3cmd ls
s3cmd ls s3://mypgbackups
s3cmd put ./date.txt s3://mypgbackups/date/date.txt
s3cmd put ./date.txt s3://mypgbackups/date.txt
s3cmd ls s3://mypgbackups
s3cmd du s3://mypgbackups
```

https://cloud.yandex.ru/ru/docs/storage/tools/s3cmd 

