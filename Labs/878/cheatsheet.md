# **To be execute in Cloud Shell only**

**Initialization**

    cluster='my-cluster'

**1. Create a Kubernetes Engine cluster**

    gcloud container clusters create $cluster

**2. Create a new Deployment - hello-server**

    kubectl create deployment hello-server \
        --image=gcr.io/google-samples/hello-app:1.0

**3. Create a Kubernetes Serivce**

    kubectl expose deployment hello-server \
        --type=LoadBalancer --port 8080

**4. Clean Up**

    gcloud container clusters delete $cluster