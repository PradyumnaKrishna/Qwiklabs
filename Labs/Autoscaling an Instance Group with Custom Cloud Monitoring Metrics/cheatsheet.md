# **To be execute in Cloud Shell only**

**1. Create a GCS bucket**

    ID=$(gcloud info --format='value(config.project)')

    cgsutil mb gs://$ID

    gsutil cp -r gs://spls/gsp087/* gs://$ID

**2. Create an Instance Template**

    gcloud compute instance-templates create autoscaling-instance01 \
        --metadata=startup-script-url=gs://$ID/startup.sh,gcs-bucket=gs://$ID


**3. Create an Instance Group**

    gcloud compute instance-groups managed create autoscaling-instance-group-1 \
        --base-instance-name=autoscaling-instance-group-1 \
        --template=autoscaling-instance01 --size=1 --zone=us-central1-c

**4. Configure Autoscaling for the Instance Group**

    gcloud beta compute instance-groups managed set-autoscaling "autoscaling-instance-group-1" \
        --zone "us-central1-c" --cool-down-period "60" --max-num-replicas "3" \
        --min-num-replicas "1" --mode "on" \
        --update-stackdriver-metric "custom.googleapis.com/appdemo_queue_depth_01" \
        --stackdriver-metric-utilization-target "150" \
        --stackdriver-metric-utilization-target-type "gauge"