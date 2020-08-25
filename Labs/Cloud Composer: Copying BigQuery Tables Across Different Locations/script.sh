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

# Create two Cloud Storage buckets.
if (gsutil mb -l US gs://$ID-us &&
    gsutil mb -l EU gs://$ID-eu)
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Bucket Created: Checkpoint Completed (2/4)'
  sleep 2.5

  # Create a dataset.
  if bq mk nyc_tlc_EU
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Dataset Created: Checkpoint Completed (3/4)'
    sleep 2.5

    # Create Cloud Composer environment.
    if  gcloud composer environments create composer-advanced-lab \
          --location us-central1
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Composer Environment Created: Checkpoint Completed (1/4)'
      sleep 2.5

      printf "\e[1m%s\n\e[m" 'Check that bucket is created or not'
      read -n 1 -r -s -p $'If Created Press ENTER\n'

      # Uploading the DAG and dependencies to Cloud Storage
      if (DAGS_BUCKET=$(gsutil list | tail -n 1) &&
          gsutil cp -r plugins/* ${DAGS_BUCKET}plugins &&
          gsutil cp bq_copy_across_locations.py ${DAGS_BUCKET}dags &&
          gsutil cp bq_copy_eu_to_us_sample.csv ${DAGS_BUCKET}dags)
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Upload Completed: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi
gcloud auth revoke --all