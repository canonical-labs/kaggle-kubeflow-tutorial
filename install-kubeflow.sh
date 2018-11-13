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
VERSION=${VERSION:-v0.2.7}

# Initialize a ksonnet app. Set the namespace for it's default environment.
APP_NAME=${APP_NAME:-my-kubeflow}
ks init ${APP_NAME}
cd ${APP_NAME}
ks env set default --namespace ${NAMESPACE}

# Install Kubeflow components
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/${VERSION}/kubeflow

# ks pkg install kubeflow/core@${VERSION}
# ks pkg install kubeflow/tf-serving@${VERSION}
# ks pkg install kubeflow/tf-job@${VERSION}

ks pkg install kubeflow/argo
ks pkg install kubeflow/core
ks pkg install kubeflow/examples
ks pkg install kubeflow/katib
ks pkg install kubeflow/mpi-job
ks pkg install kubeflow/pytorch-job
ks pkg install kubeflow/seldon
ks pkg install kubeflow/tf-serving

# Create templates for core components
ks generate kubeflow-core kubeflow-core --name=kubeflow-core
ks param set kubeflow-core jupyterHubImage gcr.io/kubeflow/jupyterhub-k8s:1.0.1
# Enable collection of anonymous usage metrics
# Skip this step if you don't want to enable collection.
ks param set kubeflow-core reportUsage true
ks param set kubeflow-core usageId $(uuidgen)
# For non-cloud use .. use NodePort (instead of ClusterIp)
ks param set kubeflow-core jupyterHubServiceType NodePort
# Deploy Kubeflow
ks apply default -c kubeflow-core

ks generate argo kubeflow-argo --name=kubeflow-argo
ks apply default -c kubeflow-argo

# NB logDir is where the TF events are written. At this high level, might not be useful
# ks is 0.2.7 complains about logDir intermittently .. will adjust for 0.3.x
# see issue https://github.com/kubeflow/kubeflow/issues/1330
# ks generate tensorboard kubeflow-tensorboard --name=kubeflow-tensorboard --logDir=logs
# ks apply default -c kubeflow-tensorboard

until [[ `kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l` == 0 ]] ; do
  echo "Checking kubeflow status until all pods are running ("`kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l`" not running). Sleeping for 10 seconds."
  sleep 10
done

# Print port information
PORT=`kubectl get svc -n=kubeflow -o go-template='{{range .items}}{{if eq .metadata.name "tf-hub-lb"}}{{(index .spec.ports 0).nodePort}}{{"\n"}}{{end}}{{end}}'`
echo ""
echo "JupyterHub Port: ${PORT}"
echo ""
