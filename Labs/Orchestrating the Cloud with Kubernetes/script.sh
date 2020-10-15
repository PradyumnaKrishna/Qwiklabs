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

gcloud container clusters create io
cd kubernetes

# Create a Kubernetes cluster and launch Nginx container
if (kubectl create deployment nginx --image=nginx:1.10.0
    kubectl expose deployment nginx --port 80 --type LoadBalancer)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Kubernetes cluster & Nginx container: Checkpoint Completed (1/5)'
  sleep 2.5

  # Create Monolith pods and service
  if (kubectl create -f pods/monolith.yaml
      kubectl create secret generic tls-certs --from-file tls/ 
      kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
      kubectl create -f pods/secure-monolith.yaml
      kubectl create -f services/monolith.yaml)
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Monlith pods and service created: Checkpoint Completed (2/5)'
    sleep 2.5

    # Allow traffic to the monolith service on the exposed nodeport
    if  gcloud compute firewall-rules create allow-monolith-nodeport \
            --allow=tcp:31000
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Traffic allowed: Checkpoint Completed (3/5)'
      sleep 2.5

      # Adding Labels to Pods
      if  kubectl label pods secure-monolith 'secure=enabled'
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Label added: Checkpoint Completed (4/5)'
        sleep 2.5

        # Deploying Applications with Kubernetes
        if (kubectl create -f deployments/auth.yaml 
            kubectl create -f services/auth.yaml 

            kubectl create -f deployments/hello.yaml 
            kubectl create -f services/hello.yaml 

            kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf 
            kubectl create -f deployments/frontend.yaml 
            kubectl create -f services/frontend.yaml)
        then
          printf "\n\e[1;96m%s\n\n\e[m" 'Applications Deployed: Checkpoint Completed (5/5)'
          sleep 2.5
          
          printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
        fi
      fi
    fi
  fi
fi

gcloud auth revoke --all
