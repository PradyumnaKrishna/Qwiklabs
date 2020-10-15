#! /bin/bash

###################################################################################################################
#                                                   MIT License                                                   # 
#                                                                                                                 #
# Copyright (c) 2020 Pradyumna Krishna | Abhinandan Arya                                                          #
#                                                                                                                 #
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated    #
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation #
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,    #
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:          #
#                                                                                                                 #
# The above copyright notice and this permission notice shall be included in all copies or substantial portions   #
# of the Software.                                                                                                #
#                                                                                                                 #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED   #
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   #
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF   #
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        #
# DEALINGS IN THE SOFTWARE.                                                                                       #
###################################################################################################################

# Initializes the Configuration
gcloud init < a

ID=$(gcloud info --format='value(config.project)')

# Create Cloud Storage Bucket
gsutil mb gs://$ID

# Create BigQuery Dataset
bq mk ecommerce

# Create BigQuery Table
bq load \
    --autodetect \
    --source_format=CSV \
    $ID:ecommerce.evenue_reporting \
    ./revenue_reporting.csv

# Run Cloud Dataprep jobs to BigQuery
if  gcloud dataflow jobs run datacloud \
      --gcs-location gs://dataflow-templates-us-central1/latest/Word_Count \
      --staging-location gs://$ID/temp \
      --parameters inputFile=gs://dataflow-samples/shakespeare/kinglear.txt,output=gs://$ID/counts
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Please Wait around 2-3 minutes for job Completion: Checkpoint Completed (1/1)'
  sleep 5

  printf "\n\e[1;92m%s\n\n\e[m" 'Script Completed'
fi
gcloud auth revoke --all