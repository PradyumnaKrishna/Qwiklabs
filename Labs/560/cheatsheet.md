# **To be execute in Cloud Shell only**

**1. Create a virtual machine instance**

    gcloud compute instances create instance-1 \
        --zone=us-central1-a \
        --image=windows-server-2012-r2-dc-v20201208 \
        --image-project=windows-cloud