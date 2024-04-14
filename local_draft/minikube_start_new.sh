# New general script for run minikube
# 1st argument (optional): cluster name, minikube profile name (default: minikube)
# 2nd argument (optional): kubernetes version (default: 1.27.4)
# 3rd argument (optional): driver (default: docker)
# 4th argument (optional): container runtime (default: docker)
# 5th argument (optional): cpu count (default: 2)
# 6th argument (optional): memory (default: 4096m)
# 7th argument (optional): additional option (for example, addons)
# Examples:
# For cluster with minikube profile name on physical host with 8CPUs and 16GB RAM, containerd runtime and addons (metallb and ingress):
# ./minikube_start_new.sh minikube 1.28 docker containerd 4 8192m --addons=metallb,ingress
# For cluster with minikube-virtualbox profile name on physical host with 8CPUs and 16GB RAM:
# ./minikube_start_new.sh minikube-virtualbox 1.27.4 virtualbox docker 4 8192m
# For cluster with default profile name (minikube) on MacOS with podman driver, cri-o container runtime:
# ./minikube_start_new.sh minikube 1.27.4 podman cri-o 3 5120m
# For cluster with test profile name, 1.24.16 k8s version, virtualbox driver, cri-o container runtime, 4 CPUs and 8192m RAM:
# ./minikube_start_new.sh test 1.24.16 virtualbox cri-o 4 8192m
# For cluster with default parameters from this script:
# ./minikube_start_new.sh
# or:
# ./minikube_start_new.sh - - - - - -
CLUSTER=${1}
K8SVER=${2}
DRIVER=${3}
CR=${4}
CPU=${5}
MEM=${6}
ADDONS=${7}
if [[ "${1}" == "" ]] || [[ "${1}" == "-" ]]; then
CLUSTER=minikube
fi
if [[ "${2}" == "" ]] || [[ "${2}" == "-" ]]; then
K8SVER=1.27.4
fi
if [[ "${3}" == "" ]] || [[ "${3}" == "-" ]]; then
DRIVER=docker
fi
if [[ "${4}" == "" ]] || [[ "${4}" == "-" ]]; then
CR=docker
fi
if [[ "${5}" == "" ]] || [[ "${5}" == "-" ]]; then
CPU=2
fi
if [[ "${6}" == "" ]] || [[ "${6}" == "-" ]]; then
MEM=4096m
fi
echo
echo "START ${CLUSTER} MINIKUBE CLUSTER (PROFILE) AFTER 5 SECONDS:"
echo
echo "minikube start -p ${CLUSTER} --kubernetes-version=v${K8SVER} --driver=${DRIVER} --container-runtime=${CR} --cpus=${CPU} --memory=${MEM} ${ADDONS}"
echo
sleep 5
minikube start -p ${CLUSTER} --kubernetes-version=v${K8SVER} --driver=${DRIVER} --container-runtime=${CR} --cpus=${CPU} --memory=${MEM} ${ADDONS}
echo
