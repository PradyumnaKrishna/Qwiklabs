#! /bin/bash


gcloud init < a

bq mk taxirides

bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime

export ID=$(gcloud info --format='value(config.project)')

gsutil mb gs://$ID

gcloud dataflow jobs run my-job \
	--gcs-location gs://dataflow-templates-us-central1/latest/PubSub_to_BigQuery \
	--region us-central1 --staging-location gs://$ID/temp \
	--parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec=$ID:taxirides.realtime
