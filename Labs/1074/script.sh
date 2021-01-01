#! /bin/bash

# Initialization
gcloud init < a

# Create a Compute Engine Virtual Machine Instance
if (gcloud compute instances create dev-instance \
        --zone=us-central1-a \
        --subnet=default \
        --metadata-from-file=startup-script=start.sh \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --tags=http-server

    gcloud compute firewall-rules create default-allow-http \
        --direction=INGRESS --priority=1000 \
        --network=default --action=ALLOW --rules=tcp:80 \
        --source-ranges=0.0.0.0/0 --target-tags=http-server)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Instance Created: Checkpoint Completed (1/3)'
  sleep 2.5

  printf "\n\e[1;96m%s\n\n\e[m" 'Other Checkpoint will complete soon'
  sleep 2.5

  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi

gcloud auth revoke --all
