#! /bin/bash

# Initialization of Script
gcloud init < a

# Create a virtual machine with gcloud
if  gcloud compute instances create gcelab2 --machine-type n1-standard-2 \
    --zone us-central1-c
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created VM Instance: Checkpoint Completed (1/1)'
  sleep 2.5

  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi

gcloud auth revoke --all
