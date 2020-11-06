# **To be execute in Cloud Shell only**

**Initialization**

    wget https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/Perform%20Foundational%20Infrastructure%20Tasks%20in%20Google%20Cloud%3A%20Challenge%20Lab/index.js
    wget https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/Perform%20Foundational%20Infrastructure%20Tasks%20in%20Google%20Cloud%3A%20Challenge%20Lab/package.json

    ID=$(gcloud info --format='value(config.project)')

    user2=<user-2>

**1. Create a GCS Bucket**

    gsutil mb gs://$ID

**2. Create a Pub/Sub topic**

    gcloud pubsub topics create my-topic

**3. Create the thumbnail Cloud Function**

    gcloud functions deploy thumbnail \
        --entry-point thumbnail \
        --trigger-bucket $ID \
        --runtime nodejs10

    gsutil cp ada.jpg gs://$ID
    
**4. Remove the previous cloud engineer**

    gcloud projects remove-iam-policy-binding $ID \
        --member=user:$user2 --role=roles/viewer
