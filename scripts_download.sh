#!/bin/bash

#
# Moves some scripts to facilitate installing tools needed to setup kubeflow, like
# microk8s and ksonnet
#
set -u

mkdir -p ${HOME}/kubeflow
cp -f ${HOME}/install-kubeflow-tools.sh ${HOME}/kubeflow/install-kubeflow-tools.sh
cp -f ${HOME}/install-kubeflow.sh ${HOME}/kubeflow/install-kubeflow.sh

grep KUBECONFIG ${HOME}/.bashrc > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Skipping adding KUBECONFIG to ~/.bashrc, already exists"
else
  echo "Adding KUBECONFIG to ~/.bashrc"
  printf "\n\nexport KUBECONFIG=/snap/microk8s/current/client.config\n\n" >> ${HOME}/.bashrc
fi
