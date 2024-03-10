# Demo Argo Workflow & ArgoCD App

## Prerequisites

### Install WSL (Windows Only)
Install WSL https://learn.microsoft.com/en-us/windows/wsl/install

### Install CLI tools
install CLI tools below:

- `Argo`: Argo is a workflow management tool designed to execute complex workflows on Kubernetes.
- `Argo CD`: Argo CD is a GitOps continuous delivery tool that ensures applications are configured correctly in Kubernetes clusters.
- `Helm`: Helm is a package manager for Kubernetes that simplifies the process of managing and deploying applications.
- `kubectl`: kubectl is the command-line interface for interacting with Kubernetes clusters.
- `k9s`: k9s is a powerful Kubernetes CLI that provides a more intuitive way to manage and monitor Kubernetes clusters.
- `kubens`: kubens is a utility that allows users to switch between Kubernetes namespaces quickly.
- `kubectx`: kubectx is a tool for managing and switching between Kubernetes contexts with ease.
- `Docker`: Docker is a platform for building, sharing, and running containerized applications.
- `Neovim`: Neovim is a highly extensible text editor that aims to improve upon the functionality of Vim.
- `jq`: jq is a lightweight and flexible command-line JSON processor that allows for easy manipulation and extraction of JSON data.
- `mktemp`: mktemp is a command-line utility used to create temporary files securely.
- `yq (yamlq)`: yq is a command-line YAML processor and JSON converter that provides a simple way to query and manipulate YAML documents.
- `Argo CD Autopilot`: Argo CD Autopilot is an automated continuous deployment solution for Kubernetes applications, built on top of Argo CD.
- `Taskfile`: Modern Mafile alternative for executing commands locally and remotely written in a popular yaml format.

Via NixOS:

    curl -L https://nixos.org/nix/install | sh
    nix-shell

To stop using installed packages, just type `exit` command and your Nix session will stop.
Search for more packages on https://search.nixos.org to try them out.

To free up Nix storage cache run:

    task clear_nix

### Setup local k8s cluster
- Install Rancher Desktop from https://rancherdesktop.io/
- Enable Kubernetes cluster feature
  ![Rancher Desktop Enable K8s](/docs/RancherDesktopEnableK8s.png)

Windows Only:
- Forward cluster to WSL via: Preferences -> WSL -> Integrations -> Ubuntu
  ![Rancher Desktop Forward K8s](/docs/RancherDesktopForwardK8s.png)

### Activate Rancher K8s Cluster Context
To work with local Rancher Desktop K8s cluster please execute following command:

    kubectx rancher-desktop

### Install Argo Workflows into the cluster

    task install_argowfl

### Install Argo Events
https://argoproj.github.io/argo-events/quick_start/

    task install_argoevents

### Install Argo CD into the cluster
https://argo-cd.readthedocs.io/en/stable/getting_started/

    task install_argocd

## Setup Docker Hub credentials

    export REGISTRY_SERVER='https://index.docker.io/v1/'
    export REGISTRY_USER='your-username'
    export REGISTRY_PASSWORD='your-password'
    export REGISTRY_EMAIL='your-email'

    task setup_docker_creds

## Setup Github Credentials

    export GIT_ACCESS_TOKEN='your-access-token'
    task create_github_creds

## Access Argo Workflow UI
   
    task argowfl

In your browser open: https://localhost:2746

![Argo Workflow](/docs/ArgoWorkflow.png)

## Access ArgoCD UI

    task argocd_pass
    task argocdui

In your browser open: https://localhost:8080

![Argo CD](/docs/ArgoCD.png)

## Create ArgoCD app

    task argocdui
    argocd login localhost:8080 
    argocd app create cicd-automation-demo --repo https://github.com/majoferenc/demo-cicd-automation-app.git  --dest-server https://kubernetes.default.svc --dest-namespace default  --path chart

## ArgoCD Notifications
https://argocd-notifications.readthedocs.io/en/stable/

