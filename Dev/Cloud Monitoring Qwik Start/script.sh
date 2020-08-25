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

gcloud init < a

read -p "Wanna set project ID press y " -n 1 -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo $'\nProject ID > '
  read ID
  gcloud config set project $ID
else
  ID=$(gcloud info --format='value(config.project)')
fi

gcloud compute instances create lamp-1-vm --machine-type n1-standard-2 \
	--zone us-central1-a \
	--metadata-from-file startup-script=start.sh \
	--tags http-server

gcloud compute firewall-rules create lamp-1-vm --allow tcp:80

gcloud compute instances describe lamp-1-vm

echo "Enter Instance ID > "

read IID

ACCESS_TOKEN="$(gcloud auth print-access-token)"

echo "Create Monitoring workspace by visiting https://console.cloud.google.com/monitoring?project=$ID\n"

read -n 1 -r -s -p $'Press enter to continue\n'

curl --request POST https://monitoring.googleapis.com/v3/projects/$ID/alertPolicies \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--data @alert.json \
	--compressed &

curl --request POST https://monitoring.googleapis.com/v3/projects/$ID/uptimeCheckConfigs \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--data '{"displayName":"Lamp Uptime Check","monitoredResource":{"type":"gce_instance","labels":{"zone":"us-central1-a","instance_id":"'"$IID"'"}},"httpCheck":{"path":"/","port":80,"requestMethod":"GET"},"period":"60s","timeout":"10s"}' \
	--compressed
