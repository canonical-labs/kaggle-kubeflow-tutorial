#!/bin/bash

#
# This will copy the scripts in the parent directory to the VM instance.
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. "${DIR}/common.sh"

gcloud compute scp --project=${GCP_PROJECT} --zone=${GCP_ZONE} ${DIR}/../*.sh ${GCP_INSTANCE_NAME}:~/
