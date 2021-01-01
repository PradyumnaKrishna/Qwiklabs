#! /bin/bash

gcloud init < a

ID=$(gcloud info --format='value(config.project)')

curl -H "Authorization: Bearer $(gcloud auth print-access-token)" \
   -X POST https://apikeys.googleapis.com/v1/projects/$ID/apiKeys

gcloud compute scp ./request.json ./result.json linux-instance:~/

gcloud auth revoke --all
