#! /bin/sh

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

printf "\n\e[1m%s\n\n\e[m" 'Warning: There is no way to create an uptime check or alert policy via script so do it on your own'
read -n 1 -r -s -p $'Press enter to continue\n'

# Initializes the Configuration
gcloud init < a
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-c

ID=$(gcloud info --format='value(config.project)')

# Create development VPC manually
if (gcloud compute networks create griffin-dev-vpc --subnet-mode custom &&
gcloud compute networks subnets create griffin-dev-wp --network=griffin-dev-vpc --region=us-central1 --range=192.168.16.0/20 &&
gcloud compute networks subnets create griffin-dev-mgmt --network=griffin-dev-vpc --region=us-central1 --range=192.168.32.0/20)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Development VPC: Checkpoint Completed (1/9)'
  sleep 2.5

  # Create production VPC using Deployment Manager
  if gcloud deployment-manager deployments create griffin-prod-vpc --config prod-network.yaml
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Created Production VPC: Checkpoint Completed (2/9)'
    sleep 2.5

    # Create bastion host
    if (gcloud compute instances create griffin-bastion --machine-type=n1-standard-1 \
          --network-interface subnet=griffin-dev-mgmt \
          --network-interface subnet=griffin-prod-mgmt --tags bastion &&

       gcloud compute firewall-rules create griffin-dev-mgmt-ssh-bastion \
          --direction=INGRESS --priority=1000 --network=griffin-dev-vpc \
          --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 \
          --source-tags bastion &&
       gcloud compute firewall-rules create griffin-prod-mgmt-ssh-bastion \
          --direction=INGRESS --priority=1000 --network=griffin-prod-vpc \
          --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 --source-tags bastion)
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created bastion host: Checkpoint Completed (3/9)'
      sleep 2.5

      # Create and configure Cloud SQL Instance
      if (gcloud sql instances create griffin-dev-db &&
          gcloud sql connect griffin-dev-db < cp)
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'SQL Instance Created: Checkpoint Completed (4/9)'
        sleep 2.5

        # Create Kubernetes cluster
        if (gcloud container clusters create griffin-dev --zone=us-central1-c \
              --machine-type=n1-standard-4 --num-nodes=2 \
              --network=griffin-dev-vpc --subnetwork griffin-dev-wp)
        then
          printf "\n\e[1;96m%s\n\n\e[m" 'Kubernetes Cluster Created: Checkpoint Completed (5/9)'
          sleep 2.5

          # Prepare the Kubernetes cluster
          sed -i "s/<Instance>/""$ID"":us-central1:griffin-dev-db/g" wp-deployment.yaml

          if (gcloud iam service-accounts keys create key.json \
                  --iam-account=cloud-sql-proxy@$ID.iam.gserviceaccount.com &&
              kubectl apply -f wp-env.yaml &&
              kubectl create secret generic cloudsql-instance-credentials --from-file key.json)
          then
            printf "\n\e[1;96m%s\n\n\e[m" 'Kubernetes Cluster Prepared: Checkpoint Completed (6/9)'
            sleep 2.5

            # Create a WordPress deployment
            if (kubectl apply -f wp-deployment.yaml &&
                kubectl apply -f wp-service.yaml)
            then
              printf "\n\e[1;96m%s\n\n\e[m" 'Wordpress Deployed: Checkpoint Completed (7/9)'
              sleep 2.5
              
              sed -i "s/""$ID"":us-central1:griffin-dev-db/<Instance>/g" wp-deployment.yaml

              # Enable Monitoring
              printf "\e[1m%s\n\e[m" 'There is no way to create an uptime check so do it on your own'
              echo "Do it on your own by visiting https://console.cloud.google.com/monitoring?project=$ID\n"
              read -n 1 -r -s -p $'Press enter to continue\n'
            
              echo "User 2 > "
              read user2

              # Provide access for an additional engineer
              if gcloud projects add-iam-policy-binding $ID --member=user:$user2 --role=roles/editor
              then
                printf "\n\e[1;96m%s\n\n\e[m" 'Provided Access: Checkpoint Completed (9/9)'
                sleep 2.5
                printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
              fi
            else
              sed -i "s/""$ID"":us-central1:griffin-dev-db/<Instance>/g" wp-deployment.yaml
            fi
          else
            sed -i "s/""$ID"":us-central1:griffin-dev-db/<Instance>/g" wp-deployment.yaml
          fi
        fi
      fi
    fi
  fi
fi