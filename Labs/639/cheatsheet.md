# **To be execute in Cloud Shell only**

**1. Clone Repository**

    git clone https://github.com/PradyumnaKrishna/Qwiklabs.git

    cd Qwiklabs/Labs/639

**2. Create Cluster with 5 Nodes**

    gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"


**3. Create uptime check & alert policy**

    kubectl create -f deployments/auth.yaml
    kubectl create -f services/auth.yaml

    kubectl create -f deployments/hello.yaml
    kubectl create -f services/hello.yaml

    kubectl create secret generic tls-certs --from-file tls/
    kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
    kubectl create -f deployments/frontend.yaml
    kubectl create -f services/frontend.yaml

**4. Canary Deployment**

    kubectl create -f deployments/hello-canary.yaml