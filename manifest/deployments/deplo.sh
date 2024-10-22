#!/bin/bash

## USE THE COMMAND:
# ./deplo.sh <github_username> <github_token> <github_email> <deplo_name>.yaml

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <GHCR_USERNAME> <GHCR_TOKEN> <GHCR_EMAIL> <DEPLOYMENT_FILE>"
    exit 1
fi

# Set variables
GHCR_USERNAME=$1
GHCR_TOKEN=$2
GHCR_EMAIL=$3
SECRET_NAME="ghcr-credentials"
DEPLOYMENT_FILE=$4

# Create the secret for GitHub Container Registry authentication
kubectl create secret docker-registry $SECRET_NAME \
    --docker-server=ghcr.io \
    --docker-username=$GHCR_USERNAME \
    --docker-password=$GHCR_TOKEN \
    --docker-email=$GHCR_EMAIL

# Check if the secret was created successfully
if [ $? -eq 0 ]; then
    echo "Secret $SECRET_NAME created successfully."
else
    echo "$SECRET_NAME already exist."
fi

# Deploy the application using the deployment YAML file
kubectl apply -f $DEPLOYMENT_FILE

# Check if the deployment was applied successfully
if [ $? -eq 0 ]; then
    echo "Deployment applied successfully."
else
    echo "Failed to apply deployment."
    exit 1
fi