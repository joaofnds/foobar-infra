# prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack

# loki
helm repo add grafana https://grafana.github.io/helm-charts
helm install -n monitoring loki grafana/loki

# promtail
helm install -n monitoring promtail grafana/promatil --values promtail-values.yaml

# postgres
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n postgres postgres bitnami/postgresql --values postgres-values.yaml

# argo cd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# argo rollouts
kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/manifests/install.yaml

# clone github.com/istio/istio and cd into it
helm install -n istio-system istio-base manifests/charts/base
helm install -n istio-system istiod manifests/charts/istio-control/istio-discovery

# kiali
helm repo add kiali https://kiali.org/helm-charts
helm update --install -n istio-system kiali-server kiali-server --values kiali-values.yaml
