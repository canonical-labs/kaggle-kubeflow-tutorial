#!/bin/bash

#
# Allow external connections on the ports listed in --rules=..
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. "${DIR}/common.sh"

gcloud compute --project=${GCP_PROJECT} firewall-rules create k8s-ingress --description=Expose\ kubernetes\ nodeport\ range --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:8001,tcp:8080,tcp:30000-32767 --source-ranges=0.0.0.0/0 --target-tags=k8s-nodeport
