#! /bin/bash

printf "\n\e[1m%s\n\n\e[m" 'Warning: There is no way to create an uptime check or alert policy via script so do it on your own'
read -n 1 -r -s -p $'Press enter to continue\n'

# Initializes the Configuration
gcloud init < a
ID=$(gcloud info --format='value(config.project)')

# Deploy Application
cd Deployment/nodejs/python
if gcloud deployment-manager deployments create advanced-configuration --config nodejs.yaml
then
  printf "\n\e[1m%s\n\n\e[m" 'Application Deployed: Checkpoint Completed (1/3)'
  sleep 2

  # Create uptime check & alert policy
  printf "\e[1m%s\n\e[m" 'There is no way to create an uptime check or alert policy via script so do it on your own'
  echo "Do it on your own by visiting https://console.cloud.google.com/monitoring?project=$ID\n"
  read -n 1 -r -s -p $'Press enter to continue\n'

  # Create Test VM with ApacheBench
  if gcloud compute instances create instance-1 \
  	    --zone us-central1-a \
	    --metadata=startup-script=sudo\ apt\ update$'\n'sudo\ apt\ -y\ install\ apache2-utils
  then
    printf "\n\e[1m%s\n\n\e[m" 'Test VM Created: Checkpoint Completed (3/3)'
  fi
  sleep 2
fi

echo "Lab Completed"