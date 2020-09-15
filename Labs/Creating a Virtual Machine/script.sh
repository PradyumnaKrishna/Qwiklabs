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

# Initialization of Script
gcloud init < a

# Create a Compute Engine instance and
# add Nginx Server to your instance with necessary firewall rules
if  gcloud compute instances create gcelab \
    --metadata-from-file startup-script=startup.sh \
    --tags http-server
then
  if  gcloud compute firewall-rules create gcelab --allow tcp:80
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Created Compute Instance and Added Nginx Server: Checkpoint Completed (1/2)'
    sleep 2.5

    # Create a new instance with gcloud.
    if  gcloud compute instances create gcelab2 --machine-type n1-standard-2 --zone us-central1-c
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'Created new Instance: Checkpoint Completed (2/2)'
      sleep 2.5

      printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
    fi
  fi
fi

gcloud auth revoke --all
