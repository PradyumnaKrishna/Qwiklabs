# **To be execute in Cloud Shell only**


    gcloud container clusters create nucleus-backend \
              --num-nodes 1 \
              --network nucleus-vpc \
              --region us-east1


    gcloud container clusters get-credentials nucleus-backend \
              --region us-east1

    kubectl create deployment hello-server \
              --image=gcr.io/google-samples/hello-app:2.0
            

    kubectl expose deployment hello-server \
              --type=LoadBalancer \
              --port 8080


    cat << EOF > startup.sh
    #! /bin/bash
    apt-get update
    apt-get install -y nginx
    service nginx start
    sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
    EOF

    gcloud compute instance-templates create nucleus-template \
             --metadata-from-file startup-script=startup.sh \
    	     --region us-east1

    gcloud compute target-pools create nucleus-pool \
	     --region us-east1

    gcloud compute instance-groups managed create nucleus-group \
             --base-instance-name nucleus \
             --size 2 \
             --template nucleus-template \
             --target-pool nucleus-pool \
	         --region us-east1

    gcloud compute instances list

    gcloud compute firewall-rules create www-firewall --allow tcp:80 

    gcloud compute forwarding-rules create nucleus-lb \
             --ports=80 \
             --target-pool nucleus-pool

    gcloud compute forwarding-rules list

    gcloud compute http-health-checks create http-basic-check \
	         --region us-east1

    gcloud compute instance-groups managed \
             set-named-ports nucleus-group \
             --named-ports http:80 \
             --region us-east1

    gcloud compute backend-services create nucleus-backend \
             --protocol HTTP --http-health-checks http-basic-check --global \
	         --region us-east1

    gcloud compute backend-services add-backend nucleus-backend \
             --instance-group nucleus-group \
             --instance-group-zone us-east1-a \
             --global

    gcloud compute url-maps create web-map \
             --default-service nucleus-backend \
	         --region us-east1


    gcloud compute target-http-proxies create http-lb-proxy \
             --url-map web-map \
	         --region us-east1

    gcloud compute forwarding-rules create http-content-rule \
             --global \
             --target-http-proxy http-lb-proxy \
             --ports 80 \
	         --region us-east1

    gcloud compute forwarding-rules list
