# !/bin/sh

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

gcloud init < a

gcloud compute instance-templates create primecalc --metadata-from-file startup-script=backend.sh --no-address --tags backend 

gcloud compute instances create frontend --zone us-central1-b --metadata-from-file startup-script=frontend.sh --tags frontend

gcloud compute firewall-rules create http --network default --allow=tcp:80 --source-ranges 10.128.0.0/20 --target-tags backend

gcloud compute instance-groups managed create backend --size 3 --template primecalc --zone us-central1-f 

gcloud compute instance-groups managed set-autoscaling backend --target-cpu-utilization 0.8 --min-num-replicas 3 --max-num-replicas 10 --zone us-central1-f 

gcloud compute health-checks create http ilb-health --request-path /2 

gcloud compute backend-services create prime-service --load-balancing-scheme internal --region us-central1 --protocol tcp --health-checks ilb-health 

gcloud compute firewall-rules create http2 --network default --allow=tcp:80 --source-ranges 0.0.0.0/0 --target-tags frontend

gcloud compute backend-services add-backend prime-service --instance-group backend --instance-group-zone us-central1-f --region us-central1 

gcloud compute forwarding-rules create prime-lb --load-balancing-scheme internal --ports 80 --network default --region us-central1 --address 10.128.10.10 --backend-service prime-service
