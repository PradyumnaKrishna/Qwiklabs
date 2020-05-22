#!/bin/sh
gcloud init < a

echo -n "Project ID > "
read ID

gsutil mb -p $ID gs://$ID

#gcloud functions deploy helloWorld --project $ID --stage-bucket $ID  --trigger-topic hello_world --region=us-central1

#gcloud alpha cloud-shell ssh
