# **To be execute in Cloud Shell only**

**1. Clone Repository**

    git clone https://github.com/PradyumnaKrishna/Qwiklabs.git
    cd Qwiklabs/Labs/981

**2. Run the Application**

    gcloud deployment-manager deployments create advanced-configuration --config nodejs.yaml


**3. Create uptime check & alert policy**

 - **There is no way to create an uptime check or alert policy via script so do it on your own**

**4. Create Test VM with ApacheBench**

    gcloud compute instances create instance-1 \
        --zone us-central1-a \
	    --metadata=startup-script=sudo\ apt\ update$'\n'sudo\ apt\ -y\ install\ apache2-utils
