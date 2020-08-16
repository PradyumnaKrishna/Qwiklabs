#!/bin/sh

gcloud init < a

gcloud compute instances create lamp-1-vm --machine-type n1-standard-2 \
	--zone us-central1-a \
	--metadata-from-file startup-script=start.sh \
	--tags http-server

gcloud compute firewall-rules create lamp-1-vm --allow tcp:80

gcloud compute instances describe lamp-1-vm

echo "Enter Instance ID > "

read IID

ACCESS_TOKEN="$(gcloud auth print-access-token)"

export ID=$(gcloud info --format='value(config.project)')

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
