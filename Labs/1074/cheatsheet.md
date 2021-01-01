# **To be execute in Cloud Shell only**

**1. Create a Compute Engine Virtual Machine Instance**

    gcloud compute instances create dev-instance \
        --zone=us-central1-a \
        --subnet=default \
        --metadata-from-file=startup-script=https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/1074/start.sh \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --tags=http-server

    gcloud compute firewall-rules create default-allow-http \
        --direction=INGRESS --priority=1000 \
        --network=default --action=ALLOW --rules=tcp:80 \
        --source-ranges=0.0.0.0/0 --target-tags=http-server

**2. Install software and configure the VM instance**
No Action Required (Wait few min)

**3. Run application software to get success response**
No Action Required (Wait few min)