#! /bin/sh

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
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-c

ID=$(gcloud info --format='value(config.project)')

API="$(gcloud iam service-accounts keys list \
  --iam-account $ID@$ID.iam.gserviceaccount.com | tail -n 1 | cut -c -40)"

ACCESS_TOKEN="$(gcloud auth print-access-token)"

# Create a dataset
if bq mk demo_dataset
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Dataset: Checkpoint Completed (1/3)'
  #sleep 2.5

  # Copy a public New York taxi table to your dataset
  if (curl --request POST 'https://bigquery.googleapis.com/bigquery/v2/projects/'$ID'/jobs?api='$API'' \
        --header 'Authorization: Bearer '$ACCESS_TOKEN'' \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data '{"configuration":{"copy":{"sourceTable":{"projectId":"bigquery-public-data","datasetId":"new_york_taxi_trips","tableId":"tlc_yellow_trips_2018"},"destinationTable":{"projectId":"'$ID'","datasetId":"demo_dataset","tableId":"trips"}}}}' \
        --compressed)
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Copied Table: Checkpoint Completed (2/3)'
    #sleep 2.5

    printf "\e[1m%s\n\e[m" 'Please visit https://console.cloud.google.com/ and accept T&C regarding API\n'
    read -n 1 -r -s -p $'Press enter to continue\n'

    #Create a tag template and attach the tag to your table
    if (gcloud data-catalog tag-templates create demo_template \
          --location=us-central1 \
          --display-name="Demo Tag Template" \
          --field=id=source,display-name="Source of data asset",type=string,required=TRUE \
          --field=id=num_rows,display-name="Number of rows in the data asset",type=double \
          --field=id=has_pii,display-name="Has PII",type=bool \
          --field=id=pii_type,display-name="PII type",type='enum(EMAIL|SOCIAL SECURITY NUMBER|NONE)' &&

        ENTRY_NAME=$(gcloud data-catalog entries lookup '//bigquery.googleapis.com/projects/'$ID'/datasets/demo_dataset/tables/trips' --format="value(name)") &&

        gcloud data-catalog tags create --entry=${ENTRY_NAME} \
          --tag-template=demo_template --tag-template-location=us-central1 --tag-file=tag_file.json)
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created Tag Template & Attached with Table: Checkpoint Completed (3/3)'
      sleep 2.5
      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi