#! /bin/bash

# Initializes the Configuration
gcloud init < a
ID=$(gcloud info --format='value(config.project)')

export INSTANCE_NAME="tenserflow-2020"
export VM_IMAGE_PROJECT="deeplearning-platform-release"
export VM_IMAGE_FAMILY="tf-latest-cpu"
export MACHINE_TYPE="n1-standard-4"
export LOCATION="us-central1-b"

# Create Storage Bucket
if gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Bucket Created: Checkpoint Completed (1/4)'
  sleep 2.5
  
  printf "\e[1m%s\n\e[m" 'Please visit https://console.cloud.google.com/ and accept T&C regarding API'
  read -n 1 -r -s -p $'Press enter to continue\n'
  
  # Create the AI Platform notebook instance
  if  gcloud beta notebooks instances create $INSTANCE_NAME \
        --vm-image-project=$VM_IMAGE_PROJECT \
        --vm-image-family=$VM_IMAGE_FAMILY \
        --machine-type=$MACHINE_TYPE --location=$LOCATION 
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'AI Notebook Created: Checkpoint Completed (2/4)'
    sleep 2.5

    printf "\e[1m%s\n\e[m" 'For Further Lab Open Up the terminal in Jupter notebook run the commands given in start.sh\n'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
  fi
fi
gcloud auth revoke --all