#!/bin/bash

#
# lazily install requirements and the kubeflow stack
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export KUBECONFIG=${KUBECONFIG:-/snap/microk8s/current/client.config}

validate_token() {
  if [ -z "$GITHUB_TOKEN" ]; then
    echo "!!! ERROR: Need to set GITHUB_TOKEN before setting up kubeflow !!!"
    exit 1
  fi
}

install_tools() {
  if hash microk8s.enable 2>/dev/null; then
    echo "Base tools (eg microk8s) already installed, skipping"
  else
    sudo ${DIR}/kubeflow/install-kubeflow-tools.sh
  fi
}

install_kubeflow() {
  ${DIR}/kubeflow/install-kubeflow.sh
}

validate_token
install_tools
install_kubeflow
