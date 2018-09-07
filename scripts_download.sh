#!/bin/bash

#
# Downloads some scripts to facilitate installing tools needed to setup kubeflow, like
# microk8s and ksonnet
#

set -u

mkdir -p ${HOME}/kubeflow
FILE=${HOME}/kubeflow/install-kubeflow-tools.sh
if [ ! -f ${FILE} ]; then
  echo "DOWNLOADING install-kubeflow-tools.sh"
  curl -L https://bit.ly/2tp2aOo > ${FILE}
  chmod a+x ${FILE}
else
  echo "SKIPPING download of install-kubeflow-tools.sh, already exists"
fi

FILE=${HOME}/kubeflow/install-kubeflow.sh
if [ ! -f ${FILE} ]; then
  echo "DOWNLOADING install-kubeflow.sh"
  curl -L https://bit.ly/2tndL0g > ${FILE}
  chmod a+x ${FILE}
else
  echo "SKIPPING download of install-kubeflow.sh, already exists"
fi

grep KUBECONFIG ${HOME}/.bashrc > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Skipping adding KUBECONFIG to ~/.bashrc, already exists"
else
  echo "Adding KUBECONFIG to ~/.bashrc"
  printf "\n\nexport KUBECONFIG=/snap/microk8s/current/client.config\n\n" >> ${HOME}/.bashrc
fi
