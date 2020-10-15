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

# Create a cloud storage bucket
if  gsutil mb gs://$ID
  then
  printf "\n\e[1;96m%s\n\n\e[m" 'Created Bucket: Checkpoint Completed (1/2)'
  sleep 2.5

  # Deploy the function
  if  gcloud functions deploy helloWorld \
          --stage-bucket $ID \
          --trigger-topic hello_world \
          --runtime nodejs8
    then
    printf "\n\e[1;96m%s\n\n\e[m" 'Function Deployed: Checkpoint Completed (2/2)'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'

    else
    printf "\n\e[1;93m%s\n\n\e[m" 'Retrying'
    sleep 5

    if  gcloud functions deploy helloWorld \
            --stage-bucket $ID \
            --trigger-topic hello_world \
            --runtime nodejs8
      then
      printf "\n\e[1;96m%s\n\n\e[m" 'Function Deployed: Checkpoint Completed (2/2)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi
gcloud auth revoke --all