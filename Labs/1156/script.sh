#! /bin/bash

# Initializes the Configuration
gcloud init < a
gcloud config set spanner/instance test-instance

# Create an Instance and Database
if (gcloud spanner instances create test-instance \
      --config=regional-us-central1 --description="My Instance" --nodes=1
    gcloud spanner databases create example-db)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Instance & Database Created: Checkpoint Completed (1/2)'
  sleep 2.5

  # Create a schema for your database
  if gcloud spanner databases ddl update example-db \
       --ddl='CREATE TABLE Singers (
         SingerId   INT64 NOT NULL,
         FirstName  STRING(1024),
         LastName   STRING(1024),
         SingerInfo BYTES(MAX),
         BirthDate  DATE,
         )PRIMARY KEY(SingerId);'
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Database Schema Created: Checkpoint Completed (2/2)'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
  fi
fi
gcloud auth revoke --all