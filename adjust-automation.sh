#!/bin/bash

# Variables 
DOCKER_PATH="docker-image"
DOCKER_IMAGE_NAME="adjust-app"
DOCKER_IMAGE_TAG="flask"
K8S_MANIFESTS_PATH="../k8s-manifests"
K8S_DNS="adjust-app.web"

# --------------------------------------------------------------------------------------------
# Before start this script, make sure you have installed minikube and kubectl on your machine
# --------------------------------------------------------------------------------------------

# Check if minikube is running
if [[ $(minikube status | grep -c "Running") -eq 0 ]]; then
  echo "Starting minikube..."
  minikube start
else
  echo "Minikube is already running."
fi

# Install addons
echo "Installing addons..."
minikube addons enable ingress
minikube addons enable ingress-dns
minikube addons enable metrics-server
echo "Waiting for addons to be applied..." 
sleep 30

# Build the docker image 
eval $(minikube docker-env)
cd $DOCKER_PATH
docker build --no-cache -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .

if [[ $? -eq 0 ]]; then
    kubectl apply -f $K8S_MANIFESTS_PATH
else 
    echo "Docker build failed!"
    exit 1
fi

# Check if the DNS record exists in /etc/hosts
if ! grep -q "^127.0.0.1 $K8S_DNS$" /etc/hosts; then 
  echo "127.0.0.1 $K8S_DNS" | sudo tee -a /etc/hosts >/dev/null
else
  echo "DNS record '$K8S_DNS' already exists in /etc/hosts"
fi