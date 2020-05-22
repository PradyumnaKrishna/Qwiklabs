#!/bin/sh
gcloud init < a
cd python-docs-samples/appengine/standard_python37/hello_world
sudo dev_appserver.py app.yaml 
gcloud app deploy
