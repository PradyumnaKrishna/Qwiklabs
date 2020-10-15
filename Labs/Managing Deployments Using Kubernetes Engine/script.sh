#! /bin/bash

###################################################################################################################
#                                                   MIT License                                                   # 
#                                                                                                                 #
# Copyright (c) 2020 Pradyumna Krishna | Abhinandan Arya                                                          #
#                                                                                                                 #
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated    #
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation #
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,    #
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:          #
#                                                                                                                 #
# The above copyright notice and this permission notice shall be included in all copies or substantial portions   #
# of the Software.                                                                                                #
#                                                                                                                 #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED   #
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   #
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF   #
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        #
# DEALINGS IN THE SOFTWARE.                                                                                       #
###################################################################################################################

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
      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi
gcloud auth revoke --all