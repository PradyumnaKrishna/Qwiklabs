#! /bin/bash

# Initialization
gcloud init < a

gcloud config set compute/zone us-central1-a
cd kubernetes

# Create cluster with 5 nodes
if gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
then
  
  # Create Deployment
  if (kubectl create -f deployments/auth.yaml
      kubectl create -f services/auth.yaml

      kubectl create -f deployments/hello.yaml
      kubectl create -f services/hello.yaml

      kubectl create secret generic tls-certs --from-file tls/
      kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
      kubectl create -f deployments/frontend.yaml
      kubectl create -f services/frontend.yaml)
  then
    printf "\n\e[1m%s\n\n\e[m" 'Created Deployments: Checkpoint Completed (1/2)'
    sleep 2.5
    
    # Canary Deployment
    if kubectl create -f deployments/hello-canary.yaml
    then
      printf "\n\e[1m%s\n\n\e[m" 'Canary Deployment: Checkpoint Completed (2/2)'
      sleep 2.5
    fi
  fi
fi

printf "\n\e[1m%s\n\n\e[m" 'Lab Completed'