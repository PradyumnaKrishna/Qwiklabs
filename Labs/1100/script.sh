#! /bin/bash

gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

gsutil mb gs://$ID

gcloud dataflow jobs run job \
	--gcs-location gs://dataflow-templates-us-central1/latest/Word_Count \
	--region us-central1 --staging-location gs://$ID/temp \
	--parameters inputFile=gs://dataflow-samples/shakespeare/kinglear.txt,output=gs://$ID/results/output