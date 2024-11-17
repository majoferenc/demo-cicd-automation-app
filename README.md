# Demo Argo Workflow & ArgoCD App
The solution was created with focus on Cloud agnostic & On Premise ready pipeline, which can be facilitated even locally.

This repository wants to achieve following CI/CD platform:

![Target Schema](/docs/target_schema.png)

## Prerequisites

### Install WSL (Windows Only)
Install WSL https://learn.microsoft.com/en-us/windows/wsl/install

## Forking and Configuring Repository for Personal Use
To use this repository for your own purposes, you'll need to fork it and trigger script `quick_replace.sh`, which will inject all necessary configuration into the pipeline definitions.

To run the script:

    git clone https://github.com/<your-username>/demo-cicd-automation-app.git
    cd demo-cicd-automation-app
    sh quick_replace.sh


### CLI tools via DevBox
We can install CLI tools via DevBox configuration, which is already prepared in this repository in a format of `devbox.json`.
To start with the installation don't forget to navigate to this repo first and navigate inside it before starting the installation, otherwise the `devbox.json` file will be not recognized and the CLI tools will be not installed.

    cd demo-cicd-automation-app

We will install following CLI tools:

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
- `Taskfile`: Modern Makefile alternative for executing commands locally and remotely written in a popular yaml format.
- `Ngrok`: A tool for creating secure tunnels to localhost, enabling public access to locally hosted services during development or testing.
- 
Via DevBox:

    curl -fsSL https://get.jetify.com/devbox | bash​

During the DevBox installation you will need to follow on screeen instructions to complete the setup.
After that you can run DevBox shell:

    devbox shell

Don't forget that every time you want to active DevBox shell and work with task commands in this repo you need to execute following:

    cd demo-cicd-automation-app
    devbox shell

To stop using installed packages, just type `exit` command and your DevBox session will stop.
Search for more packages on https://search.nixos.org to try them out.

### Setup local k8s cluster (Only if you don't have existing one)
- Install Rancher Desktop from https://rancherdesktop.io/
- Enable Kubernetes cluster feature
  ![Rancher Desktop Enable K8s](/docs/RancherDesktopEnableK8s.png)

Windows Only:
- Forward cluster to WSL via: Preferences -> WSL -> Integrations -> Ubuntu
  ![Rancher Desktop Forward K8s](/docs/RancherDesktopForwardK8s.png)
- Enable networking tunnel (You need to have latest Rancher Desktop install for this feature to work properly)
  ![Rancher Desktop Networking Tunnel](/docs/RancherNetworkTunnel.png)

### Activate Rancher K8s Cluster Context (Only if you don't have existing one)
To work with local Rancher Desktop K8s cluster please execute following command:

    kubectx rancher-desktop

### Troubleshoot Rancher K8s connection (WSL only)

When working with Rancher Desktop in WSL, if kubectx fails to find the context for Rancher Desktop or kubectl commands are timeouting, you may need to manually copy the configuration from the Windows user's `.kube/config` file (typically located at `C:\Users\[user]\.kube\config`) to the `.kube/config` file for the WSL user.

You'll need to copy the cluster configuration, user configuration, and context configuration for Rancher Desktop. Since the IP address of the cluster might change upon Rancher Desktop restart, you may need to update the server address in the `.kube/context` file after each environment restart.

Example configuration snippet:

    clusters:
      - name: rancher-desktop
        cluster:
          server: https://127.0.0.1:6443
          
Remember to update the server address to https://127.0.0.1:6443.


### Install Argo Workflows into the cluster

    task install_argowfl

### Install Argo Events
https://argoproj.github.io/argo-events/quick_start/

    task install_argoevents

### Install Argo CD into the cluster
https://argo-cd.readthedocs.io/en/stable/getting_started/

    task install_argocd

## Setup Docker Hub credentials
Update .env file in this repository. After that call:

    task setup_docker_creds

## Setup Github Credentials
Update .env file in this repository. After that call:

    task create_github_creds

## Access Argo Workflow UI

The Argo Workflow UI can be accessed in two possible ways:

The Argo Workflow UI will be available on the specified `NodePort`: https://localhost:32009

Or you can start the port-forward task, to make Argo Workflow UI available temporarily: 
   
    task argowfl

Then the Argo Workflow UI is accessible at https://localhost:2746

## Deploying Argo Workflow CI pipeline
Accessing Argo Workflow depends on your previous configuration.

If you use port-forward option, access the UI at https://localhost:2746

If you use NodePort service, access the UI at https://localhost:32009

You can find and apply workflow config at `.argo/workflow.yaml`

![Argo Workflow](/docs/ArgoWorkflow.png)

## Access ArgoCD UI

You can find and apply application config at `.argo/application.yaml`

The ArgoCD UI can be accessed in two possible ways:

Either you can create the `NodePort` service to make the ArgoCD UI available permanently on your machine by applying the configuration file:
    
    kubectl create -f .argo/argocd-nodeport-svc.yaml

Or the ArgoCD UI will be available on the specified `NodePort`: https://localhost:32008

Or you can start the port-forward task, to make ArgoCD UI available temporarily: 
   
    task argocdui

Then the ArgoCD UI is accessible at https://localhost:8080

# Login credentials:
To get password:

    task argocd_pass

ArgoCD credentials:
username: admin
password: output of argocd_pass

In your browser open: https://localhost:8080

![Argo CD](/docs/ArgoCD.png)

## Create ArgoCD app

To view or create the ArgoCD application, access the ArgoCD UI. Follow previous section (`Access ArgoCD UI`)  if necessary.

## Deploy ArgoCD deployment configuration
Don't forget to port forward first via `task argocdui` if the forwarding process is not running already.

    argocd login localhost:8080 
    argocd app create cicd-automation-demo --repo https://github.com/majoferenc/demo-cicd-automation-app.git  --dest-server https://kubernetes.default.svc --dest-namespace default  --path chart



