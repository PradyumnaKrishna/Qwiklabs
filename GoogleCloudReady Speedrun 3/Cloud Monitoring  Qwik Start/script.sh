gcloud init < a.txt
gcloud compute instances create lamp-1-vm --zone=us-central1-a --machine-type=n1-standard-2 --tags http-server
gcloud compute firewall-rules create lamp-1-vm --allow tcp:80
gcloud compute ssh --zone=us-central1-a lamp-1-vm < cp.txt


