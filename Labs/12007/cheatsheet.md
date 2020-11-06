# **To be execute in Cloud Shell only**

**Initialization**

    wget https://raw.githubusercontent.com/PradyumnaKrishna/Qwiklabs/master/Labs/12007/startup.sh

**1. Create a group of webservers**

    gcloud compute instance-templates create nginx-template \
        --metadata-from-file startup-script=startup.sh

    gcloud compute target-pools create nginx-pool

    gcloud compute firewall-rules create www-firewall --allow tcp:80

    gcloud compute instance-groups managed create nginx-group \
        --base-instance-name nginx \
        --size 2 \
        --template nginx-template \
        --target-pool nginx-pool 

**2. Create a L3 Network Load Balancer that points to the webservers**

    gcloud compute forwarding-rules create nginx-lb \
        --region us-central1 \
        --ports=80 \
        --target-pool nginx-pool

**3. Create a L7 HTTP(S) Load Balancer**

    gcloud compute http-health-checks create http-basic-check

    gcloud compute instance-groups managed \
        set-named-ports nginx-group \
        --named-ports http:80

    gcloud compute backend-services create nginx-backend \
        --protocol HTTP --http-health-checks http-basic-check --global

    gcloud compute url-maps create web-map \
        --default-service nginx-backend

    gcloud compute backend-services add-backend nginx-backend \
        --instance-group nginx-group \
        --instance-group-zone us-central1-a \
        --global

    gcloud compute target-http-proxies create http-lb-proxy \
        --url-map web-map

    gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --ports 80 