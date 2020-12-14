# **To be execute in Cloud Shell only***
<sup>*gcloud beta doesn't work in cloud shell that's why you need to proceed as per instructions after few checkpoints</sup>

**Initialization**

    ID=$(gcloud info --format='value(config.project)')
    REGION=us-central1
    wget https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/605/schema.json

**1. Create a Cloud Pub/Sub Topic**

    gcloud pubsub topics create iotlab

**2. Add IAM binding policy to Pub/Sub topic**

    gcloud pubsub topics add-iam-policy-binding iotlab \
        --member 'serviceAccount:cloud-iot@system.gserviceaccount.com' \
        --role roles/pubsub.publisher

**3. Create a BigQuery dataset**

    bq mk iotlabdataset

**4. Create an empty table in BigQuery Dataset**

    bq mk -t \
        --label organization:development \
        iotlabdataset.sensordata \
        schema.json

**5. Create a Cloud Storage Bucket**

    gsutil mb gs://$ID-bucket

**6. Set up a Cloud Dataflow Pipeline**
    gcloud dataflow jobs run iotlabflow \
        --gcs-location gs://dataflow-templates-us-central1/latest/PubSub_to_BigQuery \
        --region $REGION \
        --staging-location gs://$ID-bucket/tmp/ \
        --parameters inputTopic=projects/$ID/topics/iotlab,outputTableSpec=$ID:iotlabdataset.sensordata

**Follow further procedure according to lab**