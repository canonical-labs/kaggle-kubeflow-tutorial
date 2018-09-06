#!/bin/bash

. "common.sh"

gcloud compute --project ${GCP_PROJECT} ssh --zone ${GCP_ZONE} ${GCP_INSTANCE_NAME}
