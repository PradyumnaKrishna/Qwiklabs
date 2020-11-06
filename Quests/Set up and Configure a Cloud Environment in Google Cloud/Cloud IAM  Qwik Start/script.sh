#! /bin/bash

gcloud init < a

echo -n "Project ID > "
read ID
gsutil mb -p $ID gs://$ID
gsutil cp sample.txt gs://$ID/


echo -n "User 2 > "
read user2
gcloud projects remove-iam-policy-binding $ID \
    --member=user:$user2 --role=roles/viewer &

gcloud projects add-iam-policy-binding $ID \
    --member=user:$user2 --role=roles/storage.objectViewer
