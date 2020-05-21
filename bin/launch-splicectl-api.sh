#!/usr/bin/env bash

# Set sed command to gsed if running on mac
if [[ `uname` = "Darwin" ]]; then
    GSED=$(which gsed)
    if [[ "${GSED}" == "gsed not found" ]]; then
        echo "This script requires GNU-sed, please install with 'brew install gnu-sed'"
        exit 1
    fi
    sed_command="gsed"
else
    sed_command="sed"
fi

INGRESS_DOMAIN=$(kubectl get ingress sm-cloudmgr-ui -o json | jq -r '.spec.rules[0].host')
SECRET_NAME=$(kubectl get ingress sm-cloudmgr-ui -o json | jq -r '.spec.tls[0].secretName')

cp ./values.yaml ./values_tmp.yaml

$sed_command -i "s|REPLACE_CERTIFICATE|$SECRET_NAME|" ./values_tmp.yaml
$sed_command -i "s|REPLACE_CTLHELPER_DOMAIN|$INGRESS_DOMAIN|" ./values_tmp.yaml

helm install --name splicectl-api --values values_tmp.yaml .

rm values_tmp.yaml
