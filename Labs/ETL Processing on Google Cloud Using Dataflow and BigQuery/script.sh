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
ID=$(gcloud info --format='value(config.project)')

gcloud iam service-accounts create gcloud-auth

gcloud projects add-iam-policy-binding $ID \
    --member "serviceAccount:gcloud-auth@${ID}.iam.gserviceaccount.com" --role "roles/owner"

gcloud iam service-accounts keys create key.json \
    --iam-account gcloud-auth@${ID}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="key.json"

# Create a Cloud Storage Bucket
if gsutil mb -c regional -l us-central1 gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Bucket Created: Checkpoint Completed (1/7)'
  sleep 2.5

  # Copy Files to Your Bucket
  if (gsutil cp gs://spls/gsp290/data_files/usa_names.csv gs://$ID/data_files/ &&
      gsutil cp gs://spls/gsp290/data_files/head_usa_names.csv gs://$ID/data_files/)
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Files Copied: Checkpoint Completed (2/7)'
    sleep 2.5

    # Create the BigQuery Dataset (name: lake)
    if bq mk lake
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Dataset Created: Checkpoint Completed (3/7)'
      sleep 2.5

      # Build a Data Ingestion Dataflow Pipeline
      if python dataflow-python-examples/data_ingestion.py --project=$ID --region=us-central1 --runner=DataflowRunner --staging_location=gs://$ID/test --temp_location gs://$ID/test --input gs://$ID/data_files/head_usa_names.csv --save_main_session
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Data Ingestion Pipeline Created: Checkpoint Completed (4/7)'
        sleep 2.5

        # Build a Data Transformation Dataflow Pipeline
        if python dataflow-python-examples/data_transformation.py --project=$ID --region=us-central1 --runner=DataflowRunner --staging_location=gs://$ID/test --temp_location gs://$ID/test --input gs://$ID/data_files/head_usa_names.csv --save_main_session
        then
          printf "\n\e[1;96m%s\n\n\e[m" 'Data Transformation Pipeline Created: Checkpoint Completed (5/7)'
          sleep 2.5

          # Build a Data Enrichment Dataflow Pipeline
          if python dataflow-python-examples/data_enrichment.py --project=$ID --region=us-central1 --runner=DataflowRunner --staging_location=gs://$ID/test --temp_location gs://$ID/test --input gs://$ID/data_files/head_usa_names.csv --save_main_session
          then
            printf "\n\e[1;96m%s\n\n\e[m" 'Data Enrichment Pipeline Created: Checkpoint Completed (6/7)'
            sleep 2.5
            
            # Build a Data lake to Mart Dataflow Pipeline
            if python dataflow-python-examples/data_lake_to_mart.py --worker_disk_type="compute.googleapis.com/projects//zones//diskTypes/pd-ssd" --max_num_workers=4 --project=$ID --runner=DataflowRunner --staging_location=gs://$ID/test --temp_location gs://$ID/test --save_main_session --region=us-central1
            then
              printf "\n\e[1;96m%s\n\n\e[m" 'Data lake to Mart Pipeline Created: Checkpoint Completed (7/7)'
              sleep 2.5
              printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
            fi
          fi
        fi
      fi
    fi
  fi
fi
rm -rf key.json
gcloud auth revoke --all