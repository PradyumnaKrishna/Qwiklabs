#! /bin/bash

# Initialization of Script
gcloud init < a

# Create a Compute Engine instance and
# add Nginx Server to your instance with necessary firewall rules
if  gcloud compute instances create gcelab \
    --metadata-from-file startup-script=startup.sh \
    --tags http-server
then
  if  gcloud compute firewall-rules create gcelab --allow tcp:80
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Created Compute Instance and Added Nginx Server: Checkpoint Completed (1/2)'
    sleep 2.5

    # Create a new instance with gcloud.
    if  gcloud compute instances create gcelab2 --machine-type n1-standard-2 --zone us-central1-c
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created new Instance: Checkpoint Completed (2/2)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi

gcloud auth revoke --all
