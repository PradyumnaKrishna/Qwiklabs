#! /bin/bash

gcloud init < a

BUCKET_NAME=<PROJECT_ID>_enron_corpus

gsutil mb gs://${BUCKET_NAME}

KEYRING_NAME=test CRYPTOKEY_NAME=qwiklab

gcloud kms keyrings create $KEYRING_NAME --location global
gcloud kms keys create $CRYPTOKEY_NAME --location global \
      --keyring $KEYRING_NAME \
      --purpose encryption

gsutil cp 1.encrypted gs://${BUCKET_NAME} 

gsutil -m cp allen-p/inbox/*.encrypted gs://${BUCKET_NAME}/allen-p/inbox

