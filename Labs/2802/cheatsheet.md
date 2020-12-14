# **To be execute in Cloud Shell only***
<sup>*gcloud beta doesn't work in cloud shell that's why you need to proceed as per instructions after few checkpoints</sup>

**Initialization**

    ID=$(gcloud info --format='value(config.project)')
    wget https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/2802/end_station_data.csv
    wget https://github.com/PradyumnaKrishna/Qwiklabs/raw/master/Labs/2802/start_station_data.csv

**1. Create a cloud storage bucket**

    gsutil mb gs://$ID

**2. Upload CSV files to Cloud Storage**

    gsutil cp end_station_data.csv gs://$ID/
    gsutil cp start_station_data.csv gs://$ID/

**3. Create a CloudSQL Instance**

    gcloud sql instances create qwiklabs-demo

**4. Create a database**

    gcloud sql databases create bike --instance=qwiklabs-demo