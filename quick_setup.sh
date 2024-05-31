#!/bin/bash

sh ./quick_replace.sh

# Configurable variables
if [ -f .env ]
then
  export $(cat .env | xargs)
fi

export NIXPKGS_ALLOW_UNFREE=1

# Setup Docker Hub credentials
echo "Setting up Docker Hub credentials..."
export REGISTRY_SERVER='https://index.docker.io/v1/'
export REGISTRY_USER=$DOCKERHUB_USERNAME
export REGISTRY_PASSWORD=$DOCKERHUB_PASSWORD
export REGISTRY_EMAIL=$DOCKERHUB_EMAIL

task setup_docker_creds

# Setup GitHub credentials
echo "Setting up GitHub credentials..."
export GIT_ACCESS_TOKEN=$GIT_ACCESS_TOKEN
task create_github_creds

# Setup Rancher Desktop (if needed)
echo "Setting up Rancher Desktop..."
kubectx rancher-desktop

# Install Argo components
echo "Installing Argo Workflows..."
task install_argowfl

echo "Installing Argo Events..."
task install_argoevents

echo "Installing Argo CD..."
task install_argocd

# Access Argo Workflow UI
echo "Creating NodePort service for Argo Workflow UI..."
kubectl apply -f .argo/argo-nodeport-svc.yaml

# Deploying Argo Workflow CI pipeline
echo "Deploying Argo Workflow CI pipeline sensor..."
kubectl apply -f .argo/git_event_source.yaml
kubectl apply -f .argo/sensor.yaml
kubectl apply -f .argo/eventbus.yaml
kubectl apply -f .argo/argo-events-sa.yaml

# Access ArgoCD UI
echo "Creating NodePort service for ArgoCD UI..."
kubectl apply -f .argo/argocd-nodeport-svc.yaml

# Deploy ArgoCD application
echo "Deploying ArgoCD application..."
kubectl apply -f .argo/application.yaml

# Configure GitHub Webhook tunnel
echo "Configuring GitHub Webhook tunnel..."
export NGROK_ACC_TOKEN=$NGROK_TOKEN
ngrok config add-authtoken $NGROK_ACC_TOKEN

# Apply Argo Event Source and Sensor manifests
echo "Applying Argo Event Source and Sensor manifests..."
kubectl apply -f .argo/sensor.yaml
kubectl apply -f .argo/eventbus.yaml

# Setup ArgoCD notifications
echo "Setting up ArgoCD notifications..."
kubectl replace -n argocd configmap argocd-notifications-cm -f .argo/argocd-notifications-cm.yaml

# Create Slack Application and setup token
echo "Setting up Slack notifications..."
kubectl delete secret argocd-notifications-secret --ignore-not-found=true -n argocd
kubectl create secret generic argocd-notifications-secret -n argocd --from-literal=slack-token=$SLACK_TOKEN

echo "Setup complete!"
echo "=======> Manual Steps <======="

echo "Start Ngrok tunnel using:"
echo "task webhook_tunnel"
echo "Update git_event_source.yaml ngrok URL with generate https ngrok URL, example: https://9cb4-84-245-120-213.ngrok-free.app"

echo "Apply the file:"
echo "kubectl apply -f .argo/git_event_source.yaml"
echo "Create the GitHub Webhook, set Payload URL to https://your-ngrok-url/argo-combined-app"
echo "Run port-forward of the event service:"
echo "kubectl port-forward svc/github-eventsource-svc 12000 -n argo"
echo "Done!"
echo "Commit to your repo and observe the Workflow on:"
echo "==> https://localhost:32009"
echo "Deployment could be checked on:"
echo "==> https://localhost:32008"
echo "Get ArgoCD password via command"
echo "task argocd_pass"
