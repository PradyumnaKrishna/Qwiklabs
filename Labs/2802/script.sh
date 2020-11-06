#! /bin/bash

gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

gsutil mb -p $ID gs://$ID;
gsutil cp end_station_data.csv gs://$ID/
gsutil cp start_station_data.csv gs://$ID/

gcloud sql instances create qwiklabs-demo
gcloud sql databases create bike --instance=qwiklabs-demo

