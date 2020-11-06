#! /bin/bash

gcloud init < a

gcloud compute instances create lamp-1-vm --machine-type n1-standard-2 \
	--zone us-central1-a \
	--metadata-from-file startup-script=start.sh \
	--tags http-server

gcloud compute firewall-rules create lamp-1-vm --allow tcp:80