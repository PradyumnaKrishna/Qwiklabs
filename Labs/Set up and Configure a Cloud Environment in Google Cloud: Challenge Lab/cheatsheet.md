# **To be execute in Cloud Shell only**

**Initialization**

    gcloud config set compute/region us-central1
    gcloud config set compute/zone us-central1-c

    ID=$(gcloud info --format='value(config.project)')

    git clone https://github.com/PradyumnaKrishna/Qwiklabs.git
    cd Qwiklabs/Labs/Set\ up\ and\ Configure\ a\ Cloud\ Environment\ in\ Google\ Cloud:\ Challenge\ Lab/


**1. Create development VPC manually**

    gcloud compute networks create griffin-dev-vpc --subnet-mode custom

    gcloud compute networks subnets create griffin-dev-wp --network=griffin-dev-vpc --region=us-central1 --range=192.168.16.0/20
    gcloud compute networks subnets create griffin-dev-mgmt --network=griffin-dev-vpc --region=us-central1 --range=192.168.32.0/20

**2. Create production VPC using Deployment Manager**

    gcloud deployment-manager deployments create griffin-prod-vpc --config prod-network.yaml

**3. Create bastion host**

    gcloud compute instances create griffin-bastion --machine-type=n1-standard-1 \
        --network-interface subnet=griffin-dev-mgmt \
        --network-interface subnet=griffin-prod-mgmt --tags bastion

    gcloud compute firewall-rules create griffin-dev-mgmt-ssh-bastion \
        --direction=INGRESS --priority=1000 --network=griffin-dev-vpc \
        --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 \
        --source-tags bastion
    gcloud compute firewall-rules create griffin-prod-mgmt-ssh-bastion \
        --direction=INGRESS --priority=1000 --network=griffin-prod-vpc \
        --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 --source-tags bastion


**4. Create and configure Cloud SQL Instance**

    gcloud sql instances create griffin-dev-db
    gcloud sql connect griffin-dev-db

 - After Connecting to sql instance run the query and exit

       CREATE DATABASE wordpress;
       GRANT ALL PRIVILEGES ON wordpress.* TO "wp_user"@"%" IDENTIFIED BY "stormwind_rules";
       FLUSH PRIVILEGES;


**5. Create Kubernetes cluster**

    gcloud container clusters create griffin-dev --zone=us-central1-c \
        --machine-type=n1-standard-4 --num-nodes=2 \
        --network=griffin-dev-vpc --subnetwork griffin-dev-wp

**6. Prepare the Kubernetes cluster**

    sed -i "s/<Instance>/""$ID"":us-central1:griffin-dev-db/g" wp-deployment.yaml

    gcloud iam service-accounts keys create key.json \
                  --iam-account=cloud-sql-proxy@$ID.iam.gserviceaccount.com
    
    kubectl apply -f wp-env.yaml
    kubectl create secret generic cloudsql-instance-credentials --from-file key.json

**7. Create a WordPress deployment**

    kubectl apply -f wp-deployment.yaml &&
    kubectl apply -f wp-service.yaml

    sed -i "s/""$ID"":us-central1:griffin-dev-db/<Instance>/g" wp-deployment.yaml

**8. Enable Monitoring**

 - **There is no way to create an uptime check or alert policy via script so do it on your own**
 - Go To `Monitoring -> Uptime checks -> create uptime check`
 - Create Uptime Check with the configuration
    
    Title : griffin-uptime-check

    Target : URL

    Hostname : Use External IP get by command `gcloud compute forwarding-rules list`

    Anything else remain default

**9. Provide access for an additional engineer**

 - Type the command with replacing <user-2> with your user 2 given in the lab
  
       gcloud projects add-iam-policy-binding $ID --member=user:<user-2> --role=roles/editor