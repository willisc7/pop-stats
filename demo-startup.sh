#!/bin/bash

# Enable APIs we will be using

gcloud services enable sourcerepo.googleapis.com \
    cloudbuild.googleapis.com \
    clouddeploy.googleapis.com \
    container.googleapis.com \
    redis.googleapis.com \
    cloudresourcemanager.googleapis.com \
    servicenetworking.googleapis.com

# Give the Cloud Build service account permission to modify Cloud Deploy 
# resources and create releases to deploy on GKE. These permissions are 
# necessary for our cloudbuild.yaml file to function properly

PROJECT_NUMBER=$(gcloud projects list --filter="$(gcloud config get-value project)" --format="value(PROJECT_NUMBER)")
gcloud projects add-iam-policy-binding --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
    --role roles/clouddeploy.admin $(gcloud config get-value project)
gcloud projects add-iam-policy-binding --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
    --role roles/container.developer $(gcloud config get-value project)
gcloud projects add-iam-policy-binding --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
    --role roles/iam.serviceAccountUser $(gcloud config get-value project)
gcloud projects add-iam-policy-binding --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
    --role roles/clouddeploy.jobRunner $(gcloud config get-value project)

# Give the Cloud Deploy service account permission to deploy to GKE

gcloud projects add-iam-policy-binding --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role roles/container.admin $(gcloud config get-value project)

# Create the repo in Cloud Source Repositories

gcloud source repos create pop-stats

# Create the k8s clusters we will be using

gcloud container clusters create staging \
    --release-channel regular \
    --addons ConfigConnector \
    --workload-pool=$(gcloud config get-value project).svc.id.goog \
    --enable-stackdriver-kubernetes \
    --machine-type e2-standard-4 \
    --node-locations us-central1-c \
    --region us-central1 \
    --enable-ip-alias
gcloud container clusters create prod \
    --release-channel regular \
    --addons ConfigConnector \
    --workload-pool=$(gcloud config get-value project).svc.id.goog \
    --enable-stackdriver-kubernetes \
    --machine-type e2-standard-4 \
    --node-locations us-central1-c \
    --region us-central1 \
    --enable-ip-alias

# Push your source code to the repository you created in Cloud Source Repositories

git config --global credential.https://source.developers.google.com.helper gcloud.sh
git remote add google https://source.developers.google.com/p/$(gcloud config get-value project)/r/pop-stats
git push google master:master