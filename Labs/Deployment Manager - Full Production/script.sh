# !/bin/sh

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

printf "\n\e[1m%s\n\n\e[m" 'Warning: There is no way to create an uptime check or alert policy via script so do it on your own'
read -n 1 -r -s -p $'Press enter to continue\n'

# Initializes the Configuration
gcloud init < a
ID=$(gcloud info --format='value(config.project)')

# Deploy Application
cd Deployment/nodejs/python
if gcloud deployment-manager deployments create advanced-configuration --config nodejs.yaml
then
  printf "\n\e[1m%s\n\n\e[m" 'Application Deployed: Checkpoint Completed (1/3)'
  sleep 2

  # Create uptime check & alert policy
  printf "\e[1m%s\n\e[m" 'There is no way to create an uptime check or alert policy via script so do it on your own'
  echo "Do it on your own by visiting https://console.cloud.google.com/monitoring?project=$ID\n"
  read -n 1 -r -s -p $'Press enter to continue\n'

  # Create Test VM with ApacheBench
  if gcloud compute instances create instance-1 \
  	    --zone us-central1-a \
	    --metadata=startup-script=sudo\ apt\ update$'\n'sudo\ apt\ -y\ install\ apache2-utils
  then
    printf "\n\e[1m%s\n\n\e[m" 'Test VM Created: Checkpoint Completed (3/3)'
  fi
  sleep 2
fi

echo "Lab Completed"