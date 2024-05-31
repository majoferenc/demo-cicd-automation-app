#!/bin/bash

# Configurable variables
if [ -f .env ]
then
  export $(cat .env | xargs)
fi

# Paths and URLs
REPO_URL="https://github.com/$GITHUB_USERNAME/demo-cicd-automation-app.git"
REPO_PATH="$GITHUB_USERNAME/demo-cicd-automation-app"
LOCAL_PATH="demo-cicd-automation-app"
DOCKER_IMAGE="docker.io/$DOCKERHUB_USERNAME/argo-demo-app"
NODE_PORT_ARGO_WORKFLOW=32009
NODE_PORT_ARGOCD=32008

echo "Cleaning old config..."
kubectl delete -f .argo --ignore-not-found=true 

echo "Updating workflow.yaml..."
awk -v gh_user="$GITHUB_USERNAME" -v dh_user="$DOCKERHUB_USERNAME" '
{
  gsub("majoferenc", gh_user);
  gsub("marianferenc", dh_user);
  print
}' .argo/workflow.yaml > .argo/workflow.yaml.tmp && mv .argo/workflow.yaml.tmp .argo/workflow.yaml

echo "Updating application.yaml..."
awk -v gh_user="$GITHUB_USERNAME" -v slack_channel="$SLACK_CHANNEL_NAME" '
{
  gsub("majoferenc", gh_user);
  gsub("deployments-notification", slack_channel);
  print
}' .argo/application.yaml > .argo/application.yaml.tmp && mv .argo/application.yaml.tmp .argo/application.yaml

echo "Updating values.yaml..."
awk -v dh_user="$DOCKERHUB_USERNAME" '
{
  gsub("marianferenc", dh_user);
  print
}' chart/values.yaml > chart/values.yaml.tmp && mv chart/values.yaml.tmp chart/values.yaml

echo "Updating sensor.yaml..."
awk -v gh_user="$GITHUB_USERNAME" -v dh_user="$DOCKERHUB_USERNAME" '
{
  gsub("majoferenc", gh_user);
  gsub("marianferenc", dh_user);
  print
}' .argo/sensor.yaml > .argo/sensor.yaml.tmp && mv .argo/sensor.yaml.tmp .argo/sensor.yaml

echo "Updating git_event_source.yaml..."
awk -v gh_user="$GITHUB_USERNAME" -v dh_user="$DOCKERHUB_USERNAME" '
{
  gsub("majoferenc", gh_user);
  gsub("marianferenc", dh_user);
  print
}' .argo/git_event_source.yaml > .argo/git_event_source.yaml.tmp && mv .argo/git_event_source.yaml.tmp .argo/git_event_source.yaml

echo "Updating slack_notifications_cm.yaml..."
awk -v slack_webhook_url="$SLACK_WEBHOOK_URL" '
{
  gsub("your_webhook_url", slack_webhook_url);
  print
}' .argo/argocd-notifications-cm.yaml > .argo/argocd-notifications-cm.yaml.tmp && mv .argo/argocd-notifications-cm.yaml.tmp .argo/argocd-notifications-cm.yaml

