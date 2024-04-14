# Script for delete minikube
echo "DELETE $1 MINIKUBE CLUSTER (PROFILE) AFTER 5 SECONDS..."
sleep 5
minikube delete -p $1
