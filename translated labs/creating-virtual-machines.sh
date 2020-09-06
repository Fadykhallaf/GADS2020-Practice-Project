#!/bin/bash
gcloud config set project $(echo $GCP_PROJECT_ID)

# Debian VM1
gcloud beta compute --project=$(echo $GCP_PROJECT_ID) instances create vm-1 --zone=us-central1-c --machine-type=n1-standard-1 --subnet=default --image=debian-9-stretch-v20200902 --image-project=debian-cloud --boot-disk-size=10GB

# Windows VM2
gcloud beta compute --project=$(echo $GCP_PROJECT_ID) instances create vm-2 --zone=europe-west2-a --machine-type=n1-standard-2 --subnet=default --tags=http-server,https-server --image=windows-server-2016-dc-core-v20200813 --image-project=windows-cloud --boot-disk-size=100GB --boot-disk-type=pd-ssd

gcloud compute --project=$(echo $GCP_PROJECT_ID) firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=$(echo $GCP_PROJECT_ID) firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

gcloud beta compute reset-windows-password vm-2 --zone=europe-west2-a --user=$USER_ID

# Custom VM3
gcloud beta compute --project=$(echo $GCP_PROJECT_ID) instances create vm-3 --zone=us-west1-b --machine-type=custom-6-32768 --subnet=default --image=debian-9-stretch-v20200902 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard
