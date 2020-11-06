#! /bin/bash

#Initializing Configuration
gcloud init < a

ID=$(gcloud info --format='value(config.project)')

# Create a GCS Bucket
if  gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Bucket: Checkpoint Completed (1/3)'
  sleep 2.5

  # Copy an object to a folder in the bucket (ada.jpg)
  if  gsutil cp ./ada.jpg gs://$ID/image-folder/ada.jpg
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'File Copied: Checkpoint Completed (2/3)'
    sleep 2.5

    # Make your object publicly accessible
    if  gsutil acl ch -u AllUsers:R gs://$ID/image-folder/ada.jpg
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Changed Permission: Checkpoint Completed (3/3)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi
gcloud auth revoke --all
