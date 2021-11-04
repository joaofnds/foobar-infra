# monitoring stack
kubectl create ns monitoring

# prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack

# istio
istioctl operator init

kubectl create ns istio-system
kubectl apply -f ../istio/istio-operator.yaml
kubectl label namespace default istio-injection=enabled

# fluent bit
kubectl apply -n monitoring -f ../fluentbit

# elastic
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n monitoring elasticsearch bitnami/elasticsearch --values elastic-values.yaml

# jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install -n monitoring jaeger-operator jaegertracing/jaeger-operator
kubectl apply -f ../jaeger/jaeger-cr.yaml

# kiali
kubectl create namespace kiali-operator
helm repo add kiali https://kiali.org/helm-charts
helm install \
    --set cr.create=true \
    --set cr.namespace=istio-system \
    --namespace kiali-operator \
    kiali-operator \
    kiali/kiali-operator

kubectl apply -n istio-system -f ../kiali/kiali-cr.yaml

# argo cd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# get secret
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# argo rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml


# postgres
kubectl create ns postgres
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n postgres postgres bitnami/postgresql --values postgres-values.yaml

# sealed secrets
kubectl create ns sealed-secrets
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install -n kube-system sealed-secrets sealed-secrets/sealed-secrets
# kubectl create secret generic foo-config -n foo-staging --dry-run=client --from-file=config.yaml -o json | kubeseal --controller-name sealed-secrets



# kubectl create secret generic foo-config -n foo-staging --dry-run=client --from-file=config.yaml -o json |
#   kubeseal --controller-name sealed-secrets |
#   kubectl apply -f -
