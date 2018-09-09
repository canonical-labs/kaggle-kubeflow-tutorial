#!/bin/bash

#
# Run this file to delete kubeflow from kubernetes and directory.
#
APP_NAME=${APP_NAME:-my-kubeflow}
kubectl -n kubeflow delete po,svc --all > /dev/null 2>&1
kubectl delete namespaces kubeflow > /dev/null 2>&1
rm -fr ${APP_NAME} > /dev/null 2>&1
