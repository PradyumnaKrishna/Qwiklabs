#! /bin/bash

gcloud init < a

ID=$(gcloud info --format='value(config.project)')

gcloud compute firewall-rules create lamp-1-vm --allow tcp:80

gcloud compute instances create lamp-1-vm --machine-type n1-standard-2 \
	--zone us-central1-a \
	--metadata-from-file startup-script=start.sh \
	--tags http-server

sleep 2

IID=$(gcloud compute instances describe lamp-1-vm | grep "id:" | cut -d"'" -f 2)

ACCESS_TOKEN="$(gcloud auth print-access-token)"

echo "Create Monitoring workspace by visiting https://console.cloud.google.com/monitoring?project=$ID"

read -n 1 -r -s -p $'\nPress enter to continue\n'

sed -i "s/<Instance_ID>/""$IID""/g" uptime.json

curl --request POST https://monitoring.googleapis.com/v3/projects/$ID/alertPolicies \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--data @alert.json \
	--compressed

curl --request POST https://monitoring.googleapis.com/v3/projects/$ID/uptimeCheckConfigs \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--data @uptime.json \
	--compressed

sed -i "s/""$IID""/<Instance_ID>/g" uptime.json

gcloud auth revoke --all
