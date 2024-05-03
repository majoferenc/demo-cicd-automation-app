# Demo Argo Workflow & ArgoCD App
This repository wants to achieve following CI/CD platform:

![Target Schema](/docs/target_schema.png)

## Prerequisites

### Install WSL (Windows Only)
Install WSL https://learn.microsoft.com/en-us/windows/wsl/install

## Forking and Configuring Repository for Personal Use
To use this repository for your own purposes, you'll need to fork it and make several changes to configure it for your own GitHub repository and DockerHub username.

Fork the Repository: Fork this repository to your own GitHub account.

Update Workflow YAML:

In .argo/workflow.yaml, change the GitHub repository URL and DockerHub username:

Line 48: git clone $GIT_REPO_BASE_PATH/majoferenc/demo-cicd-automation-app.git /workspace -> Change majoferenc to your GitHub username.

Line 94: buildctl-daemonless.sh build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=docker.io/marianferenc/argo-demo-app:$GIT_HASH,push=true -> Change marianferenc to your DockerHub username.

Line 103: git clone $GIT_REPO_BASE_PATH/majoferenc/demo-cicd-automation-app.git -> Change majoferenc to your GitHub username.

Update Application Configuration:

In .argo/application.yaml, update the repository URL:

Line 20: repoURL: https://github.com/majoferenc/demo-cicd-automation-app.git -> Change majoferenc to your GitHub username (ensure case sensitivity).

Update Chart Values:

In chart/values.yaml, update the DockerHub repository:

Line 7: repository: docker.io/marianferenc/argo-demo-app -> Change marianferenc to your DockerHub username.

After making these changes, your forked repository should be configured for your personal use with updated GitHub and DockerHub references.

### CLI tools via NixOS
We can install them via NixOS configuration, which is already prepared in this repository in a format of `shell.nix`.
To start with the installation don't forget to clone this repo first and navigate inside it before starting the installation, otherwise the `shell.nix` file will be not recognized and the CLI tools will be not installed.

    git clone https://github.com/<your-username>/demo-cicd-automation-app.git
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
Via NixOS:

    export NIXPKGS_ALLOW_UNFREE=1
    curl -L https://nixos.org/nix/install | sh

During the Nix installation you will need to follow on screeen instructions to complete the setup.
After that you can run Nix shell:

    nix-shell

Don't forget that every time you want to active nix shell and work with task commands in this repo you need to execute following:

    cd demo-cicd-automation-app
    export NIXPKGS_ALLOW_UNFREE=1
    nix-shell

To stop using installed packages, just type `exit` command and your Nix session will stop.
Search for more packages on https://search.nixos.org to try them out.

After the workshop to free up Nix storage:

    task clear_nix

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

## Deploying Argo Workflow CI pipeline
Don't forget to port forward first via `task argowfl` if the forwarding process is not running already.

In your browser open: https://localhost:2746

You can find and apply workflow config at `.argo/workflow.yaml`

![Argo Workflow](/docs/ArgoWorkflow.png)

## Access ArgoCD UI

You can find and apply application config at `.argo/application.yaml`

After that forward the ArgoCD to your localhost via:

    task argocdui

ArgoCD credentials:
username: admin
password: output of argocd_pass

In your browser open: https://localhost:8080

![Argo CD](/docs/ArgoCD.png)

## Create ArgoCD app
Port forward the ArgoCD service to be able to access the UI:

    task argocdui

ArgoCD credentials:
username: admin
password: output of argocd_pass

## Deploy ArgoCD deployment configuration
Don't forget to port forward first via `task argocdui` if the forwarding process is not running already.

    argocd login localhost:8080 
    argocd app create cicd-automation-demo --repo https://github.com/majoferenc/demo-cicd-automation-app.git  --dest-server https://kubernetes.default.svc --dest-namespace default  --path chart

## Configure GitHub Webhook tunnel (To be checked)
Create Free Ngrok account: https://ngrok.com

Now obtain Ngrok Access Token: https://dashboard.ngrok.com/get-started/your-authtoken

    export NGRON_ACC_TOKEN=<your-token>
    ngrok config add-authtoken $NGROK_ACC_TOKEN
    task webhook_tunnel

Don't forget to inject generated Ngrok Public URL into github Argo Event Source `.argo/git_event_source.yaml` and apply the changes.

    apiVersion: argoproj.io/v1alpha1
    kind: EventSource
    metadata:
      name: github
    spec:
      selector:
        eventsource-name: github          # event source name
      github:
        example:                   # event name
          repositories:
            - owner: <git hub user name>
              names:
                - <name of the repo 1>
                - <name of the repo 2>
          webhook:
            endpoint: /example
            port: "12000"
            method: POST
            url: <url that is generated by ngrok>
          events:
            - "*"
          apiToken:
            name: github-access
            key: token
          insecure: true
          active: true
          contentType: json

After that you can apply the manifests:
- `.argo/git_event_source.yaml`
- `.argo/sensor.yaml`
- `.argo/webhook-eventsource.svc.yaml`

## ArgoCD Notifications
https://argocd-notifications.readthedocs.io/en/stable/

