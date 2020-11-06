#! /bin/bash

# Initializing Configuration
gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

# Create a cloud storage bucket
if  gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Bucket: Checkpoint Completed (1/2)'
  sleep 2.5

  # Deploy the function
  if  gcloud functions deploy helloWorld \
          --stage-bucket $ID \
          --trigger-topic hello_world \
          --runtime nodejs8
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Function Deployed: Checkpoint Completed (2/2)'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'

  else
    printf "\n\e[1;93m%s\n\n\e[m" 'Retrying'
    sleep 5

    if  gcloud functions deploy helloWorld \
            --stage-bucket $ID \
            --trigger-topic hello_world \
            --runtime nodejs8
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Function Deployed: Checkpoint Completed (2/2)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi
gcloud auth revoke --all