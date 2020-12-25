#! /bin/bash

# Initialization
gcloud init < a

#
if  gcloud compute instances create instance-1 \
        --zone=us-central1-a \
        --image=windows-server-2012-r2-dc-v20201208 \
        --image-project=windows-cloud
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Instance Created: Checkpoint Completed (1/1)'
  sleep 2.5

  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi

gcloud auth revoke --all
