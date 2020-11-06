#! /bin/bash

# Initializing Configuration
gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

echo -n "User 2 > "
read user2

# Create a cloud storage bucket
if  gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Bucket: Checkpoint Completed (1/4)'
  sleep 2.5

  # Create a Pub/Sub topic
  if  gcloud pubsub topics create my-topic
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Pub/Sub Topic Created: Checkpoint Completed (2/4)'
    sleep 2.5

    # Create the thumbnail Cloud Function
    if (gcloud functions deploy thumbnail \
            --entry-point thumbnail \
            --trigger-bucket $ID \
            --runtime nodejs10
        gsutil cp ada.jpg gs://$ID)
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Cloud Function Created: Checkpoint Completed (3/4)'
      sleep 2.5

      # Remove the previous cloud engineer
      if  gcloud projects remove-iam-policy-binding $ID \
              --member=user:$user2 --role=roles/viewer
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Cloud Engineer Removed: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi
gcloud auth revoke --all