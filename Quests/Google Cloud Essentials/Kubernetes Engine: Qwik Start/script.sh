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
