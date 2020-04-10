#!/bin/bash

# Script for deploying cluster services
# Author: Ilche Bedelovski

cd "$(dirname "$0")"

# Install kubectl cli
if [[ ! -f bin/kubectl ]]; then
  echo -e "\nInstalling kubectl"
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
  chmod +x ./kubectl
  mv kubectl bin/
fi

# Install helm cli
if [[ ! -f bin/helm ]]; then
  echo -e "\nInstalling helm cli"
  curl -o "$HELM_VERSION-linux-amd64.tar.gz" "https://get.helm.sh/$HELM_VERSION-linux-amd64.tar.gz"
  tar zxf "$HELM_VERSION-linux-amd64.tar.gz"
  mv linux-amd64/helm bin
  chmod +x bin/helm
  rm -Rvf linux-amd64
  rm helm-v3.1.1-linux-amd64.tar.gz
fi

# Install NGINX Ingress Controller
echo -e "\nInstalling NGINX Ingress Controller"
./bin/kubectl --kubeconfig .kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/$NGINX_VERSION/deploy/static/mandatory.yaml
./bin/kubectl --kubeconfig .kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/$NGINX_VERSION/deploy/static/provider/cloud-generic.yaml

# Creating namespaces since Helm 3 cannot create namespaces when installing application on Kubernetes
echo -e "\nCreating app namespaces"
./bin/kubectl --kubeconfig .kubeconfig create namespace $APP_NAME

# Installing Tekton on the cluster
echo -e "\nInstalling Tekton"
./bin/kubectl apply -f https://storage.googleapis.com/tekton-releases/latest/release.yaml

# Setting up Tekton cluster roles
echo -e "\nCreating Tekton cluster roles"
./bin/kubectl --kubeconfig .kubeconfig -n $TEKTON_NS create secret docker-registry docker-hub --docker-server=$CREGISTRY_HOST --docker-username=$CREGISTRY_USERNAME --docker-password=$CREGISTRY_PASSWORD --docker-email=$CREGISTRY_EMAIL
./bin/kubectl --kubeconfig .kubeconfig -n $TEKTON_NS create serviceaccount tekton-pipelines
./bin/kubectl --kubeconfig .kubeconfig create clusterrole tekton-pipelines-role --verb=get,list,watch,create,update,patch,delete --resource=deployments,deployments.apps,services,services,pods,secrets,ingress,pvc
./bin/kubectl --kubeconfig .kubeconfig create clusterrolebinding tekton-pipelines-binding --clusterrole=tekton-pipelines-role --serviceaccount=tekton-pipelines:tekton-pipelines
