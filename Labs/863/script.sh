#! /bin/bash

# Initialization
gcloud init < a

ID=$(gcloud info --format='value(config.project)')

sed -i "s/<MY_PROJECT>/""$ID""/g" vm.yaml

# Deploy your configuration
if gcloud deployment-manager deployments create my-first-deployment --config vm.yaml
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Configuration Deployed: Checkpoint Completed (1/1)'
  sleep 2.5

  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi

sed -i "s/""$ID""/<MY_PROJECT>/g" vm.yaml

gcloud auth revoke --all