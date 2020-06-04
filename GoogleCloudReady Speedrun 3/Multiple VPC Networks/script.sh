gcloud init < a.txt
#echo -n "Project ID > "
#read ID
#gcloud config set core/project $ID

gcloud compute networks create managementnet --subnet-mode=custom
gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=us-central1 --range=10.130.0.0/20
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20

gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --network=managementnet --allow tcp:22,tcp:3389,icmp
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute instances create managementnet-us-vm --zone=us-central1-c --machine-type=f1-micro --network=managementnet --subnet=managementsubnet-us
gcloud compute instances create privatenet-us-vm --zone=us-central1-c --machine-type=n1-standard-1 --subnet=privatesubnet-us
gcloud compute instances create vm-appliance --zone=us-central1-c --machine-type=n1-standard-4 \
      --network-interface network=privatenet,subnet=privatesubnet-us \
      --network-interface network=managementnet,subnet=managementsubnet-us \
      --network-interface network=mynetwork





