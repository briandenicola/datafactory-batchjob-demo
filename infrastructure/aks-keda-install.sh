#!/bin/bash

#az account set -s ${SUBSCRIPTION_ID}
#az aks get-credentials -g ${RG} -n ${CLUSTER_NAME} --overwrite-existing

helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm upgrade -i keda kedacore/keda --namespace keda --create-namespace --version 2.2.0 --set podIdentity.activeDirectory.identity=${KEDA_POD_IDENTITY}