# **To be execute in Cloud Shell only**

**Initialization**

    export ID=$(gcloud info --format='value(config.project)')

**1. Create a GCS Bucket**

    gsutil mb gs://$ID

**2. Copy an object to a folder in the bucket (ada.jpg)**

    wget -o ada.jpg https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg
    gsutil cp ./ada.jpg gs://$ID/image-folder/ada.jpg

**3. Make your object publicly accessible**

    gsutil acl ch -u AllUsers:R gs://$ID/image-folder/ada.jpg