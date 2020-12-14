#! /bin/bash

# Initialization of Script
gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

# Create a cloud storage bucket
if gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Bucket Created: Checkpoint Completed (1/4)'
  sleep 2.5

  # Upload CSV files to Cloud Storage
  if (gsutil cp end_station_data.csv gs://$ID/
      gsutil cp start_station_data.csv gs://$ID/)
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'CSV files Copied: Checkpoint Completed (2/4)'
    sleep 2.5

    # Create a CloudSQL Instance
    if gcloud sql instances create qwiklabs-demo
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'CloudSQL Instance Created: Checkpoint Completed (3/4)'
      sleep 2.5

      # Create a database
      if gcloud sql databases create bike --instance=qwiklabs-demo
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Database Created: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi

gcloud auth revoke --all