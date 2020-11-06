#! /bin/bash

# Initializing Configuration
gcloud init < a

# Create a Pub/Sub topic
if  gcloud pubsub topics create myTopic
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Pub/Sub topic Created: Checkpoint Completed (1/2)'
  sleep 2.5

  # Create Pub/Sub Subscription
  if  gcloud  pubsub subscriptions create --topic myTopic mySubscription
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Pub/Sub Subscription Created: Checkpoint Completed (2/2)'
    sleep 2.5

    printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
  fi
fi
gcloud auth revoke --all
