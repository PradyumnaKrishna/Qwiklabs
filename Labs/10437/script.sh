#! /bin/bash

gcloud init < a

export ID=$(gcloud info --format='value(config.project)')
export CAI_BUCKET_NAME=cai-$ID

gsutil mb -l us-central1 -p $ID gs://$CAI_BUCKET_NAME

gsutil cp ./resource_inventory.json gs://$CAI_BUCKET_NAME/resource_inventory.json
gsutil cp ./iam_inventory.json gs://$CAI_BUCKET_NAME/iam_inventory.json
