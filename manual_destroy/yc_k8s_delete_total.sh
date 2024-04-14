# Script for delete YC managed-kubernetes cluster (created by Terraform), kms key, service account, security groups, subnet, net
# 1st argument: cluster-name
# Example:
# ./yc_k8s_delete_total.sh my-k8s-cluster
echo
echo "LIST CLUSTERS:"
echo
yc managed-kubernetes cluster list
echo
echo "DELETE $1 CLUSTER AFTER 5 SECONDS..."
echo
sleep 5
yc managed-kubernetes cluster delete --name $1
echo
sleep 5
echo "LIST CLUSTERS:"
echo
yc managed-kubernetes cluster list
echo
echo "DELETE SYMMETRIC KEY:"
echo
yc kms symmetric-key delete --name kms-key
sleep 1
echo
echo "DELETE SERVICE ACCOUNT:"
echo
yc iam service-account delete --name my-cluster-sa
sleep 1
echo
echo "DELETE SECURITY GROUPS:"
echo
yc vpc security-group delete --name k8s-public-services
yc vpc security-group delete --name k8s-nodes-ssh-access
yc vpc security-group delete --name k8s-master-whitelist
sleep 1
echo
echo "DELETE SUBNET:"
echo
yc vpc subnet delete --name mysubnet
sleep 1
echo
echo "DELETE NET:"
yc vpc network delete --name mynet
sleep 1
echo
echo "DONE."
echo