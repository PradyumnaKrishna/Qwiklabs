#! /bin/bash

gcloud init < a

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)

gcloud iam service-accounts create my-natlang-sa \
    --display-name "my natural language service account"

gcloud iam service-accounts keys create key.json \
    --iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="key.json"

gcloud compute scp result.json linux-instance:~/result.json
