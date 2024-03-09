REGISTRY_SERVER='https://index.docker.io/v1/'

kubectl create secret docker-registry registry-creds --docker-server=$REGISTRY_SERVER --docker-username=$REGISTRY_USER --docker-password=$REGISTRY_PASSWORD
kubectl -n argo port-forward service/argo-server 2746:2746

kubectl port-forward svc/argocd-server -n argocd 8080:443
argocd login localhost:8080

argocd app create cicd-automation-demo --repo https://github.com/majoferenc/demo-cicd-automation-app.git  --dest-server https://kubernetes.default.svc --dest-namespace default  --path chart

