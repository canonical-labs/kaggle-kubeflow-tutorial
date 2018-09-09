#!/bin/bash

#
# This will create a VM instance with sufficient cores, memory, and disk to run
# this exercise. The user is responsible for defining the project.
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo ${DIR}
. "${DIR}/common.sh"

# You can associate a service account explicitly. The get_svc_account.sh script
# looks for the default *compute* service account. But, this doesn't seem necessary.
# If desired, uncomment the line, and place the argument in the create line.
#
# GCP_SVC_ACCT=${GCP_SVC_ACCT:-`./get_svc_account.sh`}
# --service-account=${GCP_SVC_ACCT}

gcloud beta compute --project=${GCP_PROJECT} instances create ${GCP_INSTANCE_NAME} --zone=${GCP_ZONE} --machine-type=n1-standard-8 --subnet=default --network-tier=PREMIUM --no-restart-on-failure --maintenance-policy=TERMINATE --service-account=default  --scopes=https://www.googleapis.com/auth/cloud-platform --tags=k8s-nodeport,http-server,https-server --image=ubuntu-1804-bionic-v20180823 --image-project=ubuntu-os-cloud --boot-disk-size=200GB --boot-disk-type=pd-standard --boot-disk-device-name=kaggle-kubeflow-1
