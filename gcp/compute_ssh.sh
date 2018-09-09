#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. "${DIR}/common.sh"

gcloud compute --project ${GCP_PROJECT} ssh --zone ${GCP_ZONE} ${GCP_INSTANCE_NAME}
