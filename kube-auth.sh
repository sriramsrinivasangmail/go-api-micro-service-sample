#!/bin/bash

export MASTER_IP=mycluster.icp
if [[ $# -eq 1 ]]; then
	export ADMIN_PASSWORD=$1
else
	export ADMIN_PASSWORD="admin"
fi

CLUSTER_NAME=mycluster.icp
ID_RESP=$(curl -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username=admin&password=$ADMIN_PASSWORD&scope=openid" https://$MASTER_IP:8443/idprovider/v1/auth/identitytoken )
ID_TOKEN=$(echo $ID_RESP| sed -e 's/.*"id_token"://' | cut -f2 -d\")
if [[ -z "${ID_TOKEN}" ]]; then
    echo "Unable to identify the ID token for kubectl from ICP auth"
    exit 1
fi

kubectl config set-cluster $CLUSTER_NAME --server=https://$MASTER_IP:8001 --insecure-skip-tls-verify=true
kubectl config set-context $CLUSTER_NAME'-context' --cluster=$CLUSTER_NAME
kubectl config set-credentials $CLUSTER_NAME'-user' --token=$ID_TOKEN
kubectl config set-context $CLUSTER_NAME'-context' --user=$CLUSTER_NAME'-user' --namespace=default
kubectl config use-context $CLUSTER_NAME'-context'

