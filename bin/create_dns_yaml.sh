#!/usr/bin/env bash

declare -A CLUSTERS
CLUSTERS["aks-dev5"]="dev6.yaml:kanyewest"
CLUSTERS["aks-dev6"]="dev5.yaml:kanyeeast"

for CLUSTER in ${!CLUSTERS[@]};do
    val=${CLUSTERS[${CLUSTER}]}
    FILENAME="${val%%:*}"
    DB_NAMESPACE="${val##*:}"

    export KUBECONFIG=~/.kube/config.${CLUSTER}
    DNS_SERVERS=$(kubectl -n kube-system get endpoints kube-dns -o json | jq '.subsets' | jq '.[].addresses' | jq -r '.[].ip')
    DNS_SERVER_LINE=$(echo ${DNS_SERVERS} | tr '\n' ' ')

    cat > ${FILENAME} <<EOT
apiVersion: v1
data:
  test.server: |
    ${DB_NAMESPACE}.svc.cluster.local:53 {
        errors
        cache 30
        forward . ${DNS_SERVER_LINE}
    }
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
  name: coredns-custom
  namespace: kube-system
EOT
done

