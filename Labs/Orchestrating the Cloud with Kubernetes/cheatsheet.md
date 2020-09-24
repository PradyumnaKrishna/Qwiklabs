# **To be execute in Cloud Shell only**

**Initialization**

    git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
    cd orchestrate-with-kubernetes/kubernetes

    gcloud container clusters create io

**1. Create a Kubernetes cluster and launch Nginx container**

    kubectl create deployment nginx --image=nginx:1.10.0

    kubectl expose deployment nginx --port 80 --type LoadBalancer

**2. Create Monolith pods and service**

    kubectl create -f pods/monolith.yaml

    kubectl create secret generic tls-certs --from-file tls/
    
    kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
    
    kubectl create -f pods/secure-monolith.yaml

    kubectl create -f services/monolith.yaml

**3. Allow traffic to the monolith service on the exposed nodeport**

    gcloud compute firewall-rules create allow-monolith-nodeport \
        --allow=tcp:31000

**4. Adding Labels to Pods**

    kubectl label pods secure-monolith 'secure=enabled'

**5. Deploying Applications with Kubernetes**

    kubectl create -f deployments/auth.yaml
    kubectl create -f services/auth.yaml

    kubectl create -f deployments/hello.yaml
    kubectl create -f services/hello.yaml

    kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
    kubectl create -f deployments/frontend.yaml
    kubectl create -f services/frontend.yaml    