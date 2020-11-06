#! /bin/bash

gcloud init < a
cd hello_world
sudo dev_appserver.py app.yaml 
gcloud app deploy
