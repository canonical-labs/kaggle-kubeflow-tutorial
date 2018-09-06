default: help

help:
	@echo "This makefile lists the common commands related to kubeflow"

###
# gcloud images
# - for more information: https://cloud.google.com/sdk/gcloud/reference/container/images/
###

list-images:
	@echo "Listing all images in the public kubeflow registry"
	gcloud container images list --repository=gcr.io/kubeflow-images-public

list-tags:
	@echo "Listing all tags of an image in the public kubeflow registry"
	@echo "FORMAT: make list-tags C=<container name>"
	gcloud container images list-tags gcr.io/kubeflow-images-public/${C}
