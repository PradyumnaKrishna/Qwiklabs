#! /bin/bash

# Initializes the Configuration
gcloud init < a

# Create a Cloud SQL instance
if  gcloud sql instances create myinstance --database-version=POSTGRES_12 --cpu=2 \
        --memory=7680MB --region="us-central"
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Cloud SQL Instance Created: Checkpoint Completed (1/1)'
  sleep 2.5
  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi
gcloud auth revoke --all