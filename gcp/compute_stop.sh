#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. "${DIR}/common.sh"

gcloud compute instances --project=${GCP_PROJECT} stop --zone=${GCP_ZONE} ${GCP_INSTANCE_NAME}
