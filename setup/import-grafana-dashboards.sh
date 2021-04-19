#!/bin/bash
# go into the dashboards folder
pushd manifests/addons/dashboards

# create the basic command to create the configmap
ISTIO_DASHBOARD_SECRET="kubectl -n monitoring create cm prometheus-oper-istio-dashboards "

# append each file to the secret
for i in *.json ; do
  echo $i
  ISTIO_DASHBOARD_SECRET="${ISTIO_DASHBOARD_SECRET} --from-file=${i}=${i}"
done
# run the secret creation command
eval $ISTIO_DASHBOARD_SECRET
# label the configmap so it is used by Grafana
kubectl label -n monitoring --overwrite cm prometheus-oper-istio-dashboards grafana_dashboard=1
popd