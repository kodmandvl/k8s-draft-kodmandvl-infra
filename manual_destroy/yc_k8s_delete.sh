# Script for delete YC managed-kubernetes cluster
# 1st argument: cluster-name
# Example:
# ./yc_k8s_delete.sh myk8s
echo
echo "LIST CLUSTERS:"
echo
yc managed-kubernetes cluster list
echo
echo "DELETE $1 CLUSTER AFTER 5 SECONDS..."
echo
sleep 5
yc managed-kubernetes cluster delete --async --name $1
echo
sleep 5
echo "LIST CLUSTERS:"
echo
yc managed-kubernetes cluster list
echo
echo "DONE."
echo