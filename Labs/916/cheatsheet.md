# **To be execute in Cloud Shell only**

**Initialization**
    
    echo 'exports.helloWorld = (data, context) => {
    const pubSubMessage = data;
    const name = pubSubMessage.data
        ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";

    console.log(`My Cloud Function: ${name}`);
    };' > index.js

    export ID=$(gcloud info --format='value(config.project)')

**1. Create a GCS Bucket**

    gsutil mb gs://$ID

**2. Deploy the function**

    gcloud functions deploy helloWorld \
        --stage-bucket $ID \
        --trigger-topic hello_world \
        --runtime nodejs8
