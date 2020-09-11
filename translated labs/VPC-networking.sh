#!/bin/bash
gcloud config set project $(echo $GCP_PROJECT_ID)

# Delete Default Netwok

gcloud compute networks delete default

# Create mynetwok
gcloud compute networks create mynetwork --subnet-mode=auto

# Create mynetwok firewall rules
gcloud compute firewall-rules create mynetwork-allow-icmp-ssh-rdp --direction=INGRESS --priority=65534 --network=mynetwork --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp,tcp:22,tcp:3389

# Create VM1
gcloud compute instances create mynet-us-vm --zone=us-central1-c --machine-type=n1-standard-1 --subnet=mynetwork --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=mynet-us-vm

# Create VM2
gcloud compute instances create mynet-eu-vm --zone=europe-west1-c --machine-type=n1-standard-1 --subnet=mynetwork --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=mynet-eu-vm


# Change mode to custom

gcloud compute networks update mynetwork --switch-to-custom-subnet-mode


# Create managementnetwork

gcloud compute networks create managementnet --subnet-mode=custom
gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=us-central1 --range=10.130.0.0/20

# Create privatenet
gcloud compute networks create privatenet --subnet-mode=custom 
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20


# Create managementnet-allow-icmp-ssh-rdp firewall rule
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

# Create privatenet-allow-icmp-ssh-rdp firewall rule
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0


# Create a managementnet-us-vm
gcloud compute instances create managementnet-us-vm --zone=us-central1-c --machine-type=f1-micro --subnet=managementsubnet-us --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=managementnet-us-vm

# Create a privatenet-us-vm
gcloud compute instances create privatenet-us-vm --zone=us-central1-c --machine-type=f1-micro --subnet=privatesubnet-us --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm

