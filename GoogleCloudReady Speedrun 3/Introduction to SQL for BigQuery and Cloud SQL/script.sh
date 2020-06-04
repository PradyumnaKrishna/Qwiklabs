gcloud init < a.txt


echo -n "Project ID > "
read ID
gcloud config set project $ID

gsutil mb -p $ID gs://$ID;
gsutil cp end_station_data.csv gs://$ID/
gsutil cp start_station_data.csv gs://$ID/

gcloud sql instances create qwiklabs-demo
gcloud sql databases create bike --instance=qwiklabs-demo

