#!/bin/sh
gcloud init < a
gcloud compute instances create gcelab --machine-type n1-standard-2 --zone us-central1-c --tags http-server
gcloud compute firewall-rules create gcelab --allow tcp:80
gcloud compute ssh --zone us-central1-c gcelab
gcloud compute instances create gcelab2 --machine-type n1-standard-2 --zone us-central1-c

