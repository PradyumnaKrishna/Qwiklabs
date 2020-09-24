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

# Initialization of Script
gcloud init < a

# Create a group of webservers
if (gcloud compute instance-templates create nginx-template \
        --metadata-from-file startup-script=startup.sh

    gcloud compute target-pools create nginx-pool

    gcloud compute firewall-rules create www-firewall --allow tcp:80

    gcloud compute instance-groups managed create nginx-group \
        --base-instance-name nginx \
        --size 2 \
        --template nginx-template \
        --target-pool nginx-pool )
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Group of webservers: Checkpoint Completed (1/3)'
  sleep 2.5

  # Create a L3 Network Load Balancer that points to the webservers
  if  gcloud compute forwarding-rules create nginx-lb \
          --region us-central1 \
          --ports=80 \
          --target-pool nginx-pool
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'L3 Network Load Balancer Created: Checkpoint Completed (2/3)'
    sleep 2.5

    # Create a L7 HTTP(S) Load Balancer
    if (gcloud compute http-health-checks create http-basic-check

        gcloud compute instance-groups managed \
              set-named-ports nginx-group \
              --named-ports http:80

        gcloud compute backend-services create nginx-backend \
            --protocol HTTP --http-health-checks http-basic-check --global

        gcloud compute url-maps create web-map \
            --default-service nginx-backend

        gcloud compute backend-services add-backend nginx-backend \
            --instance-group nginx-group \
            --instance-group-zone us-central1-a \
            --global

        gcloud compute target-http-proxies create http-lb-proxy \
            --url-map web-map

        gcloud compute forwarding-rules create http-content-rule \
            --global \
            --target-http-proxy http-lb-proxy \
            --ports 80 )
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created L7 HTTP(s) Load Balancer: Checkpoint Completed (3/3)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi

gcloud auth revoke --all
