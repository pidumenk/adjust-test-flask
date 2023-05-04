# adjust-test
The repository contains a web-app written on Python and the configuration files running the application on Minikube.

## Prerequisites 
To sucessfully deploy the application you should have installed on your laptop the following dependencies:

  * [docker](https://docs.docker.com/desktop/install/mac-install/)
  * [minikube](https://minikube.sigs.k8s.io/docs/start/)
  * [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos)
  
Please, refer to the documentation to install mentioned above requirements regarding your OS.

## Automatically bootstrap the local sandbox and application on Minikube

I'm using MacOS and have already installed my local sandbox.

```bash
# Install minikube (Homebrew)
brew install minikube

# Install kubectl (Honebrew)
brew install kubectl
```

Make a clone the current repository on your local machine and run `adjust-automation.sh` script.

```bash
# Get into directory
cd <PATH_TO_THE_REPOSITORY>

# Run the script
./adjust-automation.sh

# Run minikube tunnel 
minikube tunnel

# Make a request in a new terminal tab to the application
curl adjust-app.web
2023-04-28 19:25:48 adjust-deploy-59bcfb95bb-rn8mw

# Check app and node metrics 
kubectl top pod --containers
POD                              NAME         CPU(cores)   MEMORY(bytes)
adjust-deploy-59bcfb95bb-chrw7   adjust-app   1m           11Mi
adjust-deploy-59bcfb95bb-rn8mw   adjust-app   1m           11Mi
adjust-deploy-59bcfb95bb-trmlg   adjust-app   1m           11Mi

kubectl top node
NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
minikube   309m         7%     996Mi           12%
```
## Detailed instructions on how to build and deploy the application (manually)
Clone this repository to your local machine. 

```bash
# Get into directory
cd ~/adjust-test/docker-image

# Build docker image
docker build -t adjust-app .

# Run the app in k8s cluster
minikube start
minikube addons enable ingress
minikube addons enable ingress-dns
minikube addons enable metrics-server
kubectl create -f ../k8s-manifests

# Check that all resources have been deployed
kubectl get all && kubectl get ingress

# Add your local dns-record into /etc/hosts
sudo sh -c "echo '127.0.0.1 adjust-app.web' >> /etc/hosts"

# Run minikube tunnel 
minikube tunnel 

# Make requests in a new terminal tab to the application and make sure all things are working properly
for i in {1..10}; do curl adjust-app.web; done
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-rn8mw
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-trmlg
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-trmlg
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-trmlg
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-rn8mw
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-chrw7
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-trmlg
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-rn8mw
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-rn8mw
2023-04-28 19:39:13 adjust-deploy-59bcfb95bb-chrw7

# Check app and node metrics 
kubectl top pod --containers
POD                              NAME         CPU(cores)   MEMORY(bytes)
adjust-deploy-59bcfb95bb-chrw7   adjust-app   1m           11Mi
adjust-deploy-59bcfb95bb-rn8mw   adjust-app   1m           11Mi
adjust-deploy-59bcfb95bb-trmlg   adjust-app   1m           11Mi

kubectl top node
NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
minikube   309m         7%     996Mi           12%
```
## Additional information
Running services in the local environment may require additional configuration depending on the environment (kind, minikube, k3s). In this case to display ingress requests, [minikube tunnel should be runnig](https://stackoverflow.com/a/73735009). More information related to Minikube on MacOS - [here](https://github.com/kubernetes/minikube/issues/13510#issuecomment-1130152467).  

In order to use local docker images with Minikube, [following steps](https://stackoverflow.com/a/42564211) need to be done.

Additionally, I have built the image and uploaded it on Docker Hub. If it's necessary, it could be configured on k8s manifest file.

`docker pull pidumenk/adjust-app:latest`
