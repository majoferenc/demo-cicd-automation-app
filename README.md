# Demo Argo Workflow & ArgoCD App

## Prerequisites

### Install CLI tools
install argo, argocd, helm, kubectl, k9s, kubens, kubectx, docker

### Setup local k8s cluster
Rancher Desktop

### Install Argo Workflows into the cluster

### Install Argo CD into the cluster

## Setup Docker Hub credentials

    REGISTRY_SERVER='https://index.docker.io/v1/'
    REGISTRY_USER
    $REGISTRY_PASSWORD
    REGISTRY_EMAIL
    
    kubectl create secret docker-registry registry-creds --docker-server=$REGISTRY_SERVER --docker-username=$REGISTRY_USER --docker-password=$REGISTRY_PASSWORD --docker-email=$REGISTRY_EMAIL -o yaml

    kubectl create secret generic config.json --from-file=config.json

    kubectl -n argo port-forward service/argo-server 2746:2746

## Create ArgoCD app

    kubectl port-forward svc/argocd-server -n argocd 8080:443
    argocd login localhost:8080 
    argocd app create cicd-automation-demo --repo https://github.com/majoferenc/demo-cicd-automation-app.git  --dest-server https://kubernetes.default.svc --dest-namespace default  --path chart

