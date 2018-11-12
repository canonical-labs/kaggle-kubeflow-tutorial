#!/usr/bin/env bash

error() {
    printf '\E[31m'; echo "$@"; printf '\E[0m'
}

if [[ -z "${GITHUB_TOKEN}" ]]; then
    error "The GITHUB_TOKEN environment variable isn't set."
    error "Please visit https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"
    exit 1
fi

set -e  # exit immediately on error
set -u  # fail on undeclared variables

# Create a namespace for kubeflow deployment
NAMESPACE=${NAMESPACE:-kubeflow}
kubectl create namespace ${NAMESPACE}

# Which version of Kubeflow to use
# For a list of releases refer to:
# https://github.com/kubeflow/kubeflow/releases
VERSION=${VERSION:-v0.1.3}

# Initialize a ksonnet app. Set the namespace for it's default environment.
APP_NAME=${APP_NAME:-my-kubeflow}
ks init ${APP_NAME}
cd ${APP_NAME}
ks env set default --namespace ${NAMESPACE}

# Install Kubeflow components
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/${VERSION}/kubeflow

ks pkg install kubeflow/core@${VERSION}
ks pkg install kubeflow/tf-serving@${VERSION}
ks pkg install kubeflow/tf-job@${VERSION}

# Create templates for core components
ks generate kubeflow-core kubeflow-core

# If your cluster is running on Azure you will need to set the cloud parameter.
# If the cluster was created with AKS or ACS choose aks, it if was created
# with acs-engine, choose acsengine
# PLATFORM=<aks|acsengine>
# ks param set kubeflow-core cloud ${PLATFORM}

# Enable collection of anonymous usage metrics
# Skip this step if you don't want to enable collection.
ks param set kubeflow-core reportUsage true
ks param set kubeflow-core usageId $(uuidgen)

# For non-cloud use .. use NodePort (instead of ClusterIp)
ks param set kubeflow-core jupyterHubServiceType NodePort

# Deploy Kubeflow
ks apply default -c kubeflow-core

until [[ `kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l` == 0 ]] ; do
  echo "Checking kubeflow status until all pods are running ("`kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l`" not running). Sleeping for 10 seconds."
  sleep 10
done

# Print port information
PORT=`kubectl get svc -n=kubeflow -o go-template='{{range .items}}{{if eq .metadata.name "tf-hub-lb"}}{{(index .spec.ports 0).nodePort}}{{"\n"}}{{end}}{{end}}'`
echo ""
echo "JupyterHub Port: ${PORT}"
echo ""
