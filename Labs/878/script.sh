#! /bin/bash

# Initialization of Script
gcloud init < a
cluster='my-cluster'

# Create a Kubernetes Engine cluster
if  gcloud container clusters create $cluster --no-enable-autoupgrade --no-enable-ip-alias
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Cluster: Checkpoint Completed (1/4)'
  sleep 2.5

  # Create a new Deployment - hello-server
  if  kubectl create deployment hello-server \
          --image=gcr.io/google-samples/hello-app:1.0
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Hello-Server Deployed: Checkpoint Completed (2/4)'
    sleep 2.5

    # Create a Kubernetes Serivce
    if  kubectl expose deployment hello-server \
            --type=LoadBalancer --port 8080
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created Kubernetes Service: Checkpoint Completed (3/4)'
      sleep 2.5

      # Clean Up
      if  gcloud container clusters delete $cluster
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Cleaned Up: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi

gcloud auth revoke --all
