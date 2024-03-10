# shell.nix

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.argo
    pkgs.argocd
    pkgs.kubernetes-helm
    pkgs.kubectl
    pkgs.k9s
    pkgs.kubectx
    pkgs.docker
    pkgs.neovim
    pkgs.jq
    pkgs.mktemp
    pkgs.yq
    pkgs.argocd-autopilot
    pkgs.go-task
  ];
}

