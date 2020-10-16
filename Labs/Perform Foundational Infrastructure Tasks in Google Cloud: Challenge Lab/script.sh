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

# Initializing Configuration
gcloud init < a

export ID=$(gcloud info --format='value(config.project)')

echo -n "User 2 > "
read user2

# Create a cloud storage bucket
if  gsutil mb gs://$ID
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Bucket: Checkpoint Completed (1/4)'
  sleep 2.5

  # Create a Pub/Sub topic
  if  gcloud pubsub topics create my-topic
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Pub/Sub Topic Created: Checkpoint Completed (2/4)'
    sleep 2.5

    # Create the thumbnail Cloud Function
    if (gcloud functions deploy thumbnail \
            --entry-point thumbnail \
            --trigger-bucket $ID \
            --runtime nodejs10
        gsutil cp ada.jpg gs://$ID)
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Cloud Function Created: Checkpoint Completed (3/4)'
      sleep 2.5

      # Remove the previous cloud engineer
      if  gcloud projects remove-iam-policy-binding $ID \
              --member=user:$user2 --role=roles/viewer
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Cloud Engineer Removed: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi
gcloud auth revoke --all