# Introduction

The following sections assume you have signed up for google cloud.
If you haven't done this step, please visit the [gcp signup page](https://cloud.google.com/). You can start for free.

# GCP Setup Instructions

1. Please [create a project](https://console.cloud.google.com/projectcreate)
  1. You'll use this project id for the commands in this directory
2. If using a local terminal / shell:
  1. Please install gcloud:
    1. Visit the [interactive install page](https://cloud.google.com/sdk/docs/downloads-interactive)
    2. Ensure you run `gcloud init`
3. Otherwise, you can use the gcp shell in your browser.
  1. Navigate to the [gcp dashboard](https://console.cloud.google.com/home/dashboard)
  2. Select the `>_` image in the upper right part of the top level tool bar
  3. NB: you get do a `git clone` of this project inside the cloud shell

# Creating a VM for the kaggle-kubeflow tutorial

From this directory, you should run the following commands to
create the initial VM and log in. It is important that you set
the project id first, there are sensible defaults for everything
else:

```
export GCP_PROJECT=<the Project Id of the project you created>
./network_create.sh
./compute_create.sh
./compute_ssh.sh
```

# Stop / Delete / Start

For ongoing use, you can stop and start anytime. When you are
completely done, please delete the VM.

You don't pay money for the VM when it is stopped, but you do
pay for the attached disk (for what has been used).

```
# If you haven't already, create GCP_PROJECT ..
export GCP_PROJECT=<the Project Id of the project you created>

# To stop a running VM
./compute_stop.sh

# To start a stopped VM
./compute_start.sh

# To delete a VM (in any state)
./compute_delete.sh

```
