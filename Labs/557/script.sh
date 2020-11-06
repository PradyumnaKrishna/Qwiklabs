#! /bin/bash

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
