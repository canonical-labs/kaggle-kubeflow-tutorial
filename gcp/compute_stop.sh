#!/bin/bash

. "common.sh"

gcloud compute instances --project=${GCP_PROJECT} stop --zone=${GCP_ZONE} ${GCP_INSTANCE_NAME}
