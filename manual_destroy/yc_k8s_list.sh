# Script for get list of YC managed-kubernetes clusters
# Example:
# ./yc_k8s_list.sh
echo
echo "LIST CLUSTERS:"
echo
yc managed-kubernetes cluster list
echo
echo "DONE."
echo