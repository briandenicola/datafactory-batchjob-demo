#!/bin/bash

export SUBSCRIPTION_ID=$1
export RG=$2
export CLUSTER_NAME=$3
export KEDA_IDENTITY=$4
export BATCH_IDENTITY=$5

az account set -s ${SUBSCRIPTION_ID}
#az aks get-credentials -g ${RG} -n ${CLUSTER_NAME} --overwrite-existing

helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm upgrade -i keda kedacore/keda --namespace keda --create-namespace --version 2.2.0 --set podIdentity.activeDirectory.identity=${KEDA_IDENTITY}

RESOURCEID=`az identity show --name ${KEDA_IDENTITY} --resource-group ${RG} --query id -o tsv`
az aks pod-identity add --resource-group ${RG} --cluster-name ${CLUSTER_NAME} --namespace keda --name ${KEDA_IDENTITY} --identity-resource-id ${RESOURCEID}

RESOURCEID=`az identity show --name ${BATCH_IDENTITY} --resource-group ${RG} --query id -o tsv`
az aks pod-identity add --resource-group ${RG} --cluster-name ${CLUSTER_NAME} --namespace default --name ${BATCH_IDENTITY} --identity-resource-id ${RESOURCEID}