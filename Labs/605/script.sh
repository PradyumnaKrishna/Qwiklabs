#! /bin/bash

# Initialization
gcloud init < a

ID=$(gcloud info --format='value(config.project)')
REGION=us-central1

# Create a Cloud Pub/Sub Topic
if gcloud pubsub topics create iotlab
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Pub/Sub Topic Created: Checkpoint Completed (1/8)'
  sleep 2.5

  # Add IAM binding policy to Pub/Sub topic
  if  gcloud pubsub topics add-iam-policy-binding iotlab \
          --member 'serviceAccount:cloud-iot@system.gserviceaccount.com' \
          --role roles/pubsub.publisher
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'IAM binding policy Added: Checkpoint Completed (2/8)'
    sleep 2.5

    # Create a BigQuery dataset
    if bq mk iotlabdataset
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'BigQuery Dataset Created: Checkpoint Completed (3/8)'
      sleep 2.5

      # Create an empty table in BigQuery Dataset
      if  bq mk -t \
              --label organization:development \
              iotlabdataset.sensordata \
              schema.json
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'BigQuery Dataset Created: Checkpoint Completed (4/8)'
        sleep 2.5

        # Create a Cloud Storage Bucket
        if gsutil mb gs://$ID-bucket
        then
          printf "\n\e[1;96m%s\n\n\e[m" 'Bucket Created: Checkpoint Completed (5/8)'
          sleep 2.5

          # Set up a Cloud Dataflow Pipeline
          if  gcloud dataflow jobs run iotlabflow \
                  --gcs-location gs://dataflow-templates-us-central1/latest/PubSub_to_BigQuery \
                  --region $REGION \
                  --staging-location gs://$ID-bucket/tmp/ \
                  --parameters inputTopic=projects/$ID/topics/iotlab,outputTableSpec=$ID:iotlabdataset.sensordata
          then
            printf "\n\e[1;96m%s\n\n\e[m" 'Pipeline Created: Checkpoint Completed (6/8)'
            sleep 2.5

            # Create a Registry for IoT Devices
            if  gcloud beta iot registries create iotlab-registry \
                    --project $ID \
                    --region $REGION \
                    --event-notification-config=topic=projects/$ID/topics/iotlab
            then
              printf "\n\e[1;96m%s\n\n\e[m" 'Registry Created: Checkpoint Completed (7/8)'
              sleep 2.5

              openssl req -x509 -newkey rsa:2048 -keyout rsa_private.pem \
                   -nodes -out rsa_cert.pem -subj "/CN=unused"

              # Add Simulated Devices to the Registry
              if (gcloud beta iot devices create temp-sensor-buenos-aires \
                      --project=$ID \
                      --region=$REGION \
                      --registry=iotlab-registry \
                      --public-key path=rsa_cert.pem,type=rs256

                  gcloud beta iot devices create temp-sensor-istanbul \
                        --project=$ID \
                        --region=$REGION \
                        --registry=iotlab-registry \
                        --public-key path=rsa_cert.pem,type=rs256)
              then
                printf "\n\e[1;96m%s\n\n\e[m" 'Added Simulated Devices to the Registry: Checkpoint Completed (8/8)'
                sleep 2.5

                printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
              fi
            fi
          fi
        fi
      fi
    fi
  fi
fi

gcloud auth revoke --all