#! /bin/bash

gcloud init < a

gcloud compute instances create blue --machine-type n1-standard-1 \
	--zone us-central1-a \
	--metadata=startup-script=sudo\ apt\ update$'\n'sudo\ apt-get\ install\ nginx-light\ -y$'\n'sudo\ service\ nginx\ restart \
	--tags=web-server 

gcloud compute instances create green --machine-type n1-standard-1 \
	--zone us-central1-a \
	--metadata=startup-script=sudo\ apt\ update$'\n'sudo\ apt-get\ install\ nginx-light\ -y$'\n'sudo\ service\ nginx\ restart 

gcloud compute firewall-rules create allow-http-web-server \
	--direction=INGRESS --priority=1000 \
	--network=default --action=ALLOW --rules=tcp:80,icmp \
	--source-ranges=0.0.0.0/0 --target-tags=web-server 

gcloud compute instances create test-vm --machine-type=f1-micro \
	 --subnet=default --zone=us-central1-a 

gcloud iam service-accounts create network-admin \
	--display-name=Network-admin