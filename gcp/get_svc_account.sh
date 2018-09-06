#!/bin/bash

. "common.sh"

gcloud beta iam service-accounts list --project ${GCP_PROJECT} | grep compute | rev | cut -d' ' -f 1 | rev
