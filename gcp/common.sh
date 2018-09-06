#!/bin/bash

#
# The user is responsible for defining the project (ie export GCP_PROJECT=).
# The other variables are sensible defaults.
#

if [ -z "$GCP_PROJECT" ]; then
    echo "Need to set GCP_PROJECT to your GCP Project ID"
    exit 1
fi

# in case a var is introduced and not set ..
set -u

GCP_ZONE=${GCP_ZONE:-"us-east1-b"}
GCP_INSTANCE_NAME=${GCP_INSTANCE_NAME:-"kaggle-kubeflow-1"}
