#! /bin/bash


gcloud init < a

gcloud compute scp ./request.json ./result.json linux-instance:~/
