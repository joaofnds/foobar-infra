# monitoring stack
kubectl create ns monitoring

# prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack

# istio
asdf plugin-add istioctl
asdf install istioctl 1.9.3
asdf global istioctl 1.9.3
istioctl operator init

kubectl create ns istio-system
kubectl apply -f ../istio/istio-operator.yaml

kubectl label namespace default istio-injection=enabled

# elastic
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n monitoring elasticsearch bitnami/elasticsearch --values elastic-values.yaml

# fluent bit
kubectl apply -n monitoring -f ../fluentbit

# jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install -n monitoring jaeger-operator jaegertracing/jaeger-operator
kubectl apply -f ../jaeger/jaeger-cr.yaml

# kiali
kubectl create namespace kiali-operator
helm install \
    --set cr.create=true \
    --set cr.namespace=istio-system \
    --namespace kiali-operator \
    --repo https://kiali.org/helm-charts \
    kiali-operator \
    kiali-operator

kubectl apply -n istio-system -f ../kiali/kiali-cr.yaml

# argo cd
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# argo rollouts
# helm repo add argo https://argoproj.github.io/argo-helm
# helm install -n argocd argo-rollouts argo/argo-rollouts
# or from master
kubectl create ns argo-rollouts
kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/manifests/install.yaml

# postgres
kubectl create ns postgres
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n postgres postgres bitnami/postgresql --values postgres-values.yaml

# sealed secrets
kubectl create ns sealed-secrets
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install -n sealed-secrets sealed-secrets sealed-secrets/sealed-secrets