#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. "${DIR}/common.sh"

gcloud compute instances --project=${GCP_PROJECT} list --filter="--zone:(${GCP_ZONE})" --filter="name=(${GCP_INSTANCE_NAME})"
