#!/usr/bin/env bash

function connect_k8s_vault {

    AWSPROFILE=${AWS_PROFILE:-splice-nonprod}
    CSP=$(kubectl -n splice-system get secret/vault-key-store -o json | jq -r '.data.CLOUD_PROVIDER' | base64 -d)
    vaultname="$(kubectl -n splice-system get secret vault-key-store -o json | jq -r .data.ENVIRONMENT | base64 -d | tr -d '-')vault"
    SPLICE_ENV=$(kubectl -n splice-system get secret vault-key-store -o json | jq -r .data.ENVIRONMENT | base64 -d)
    export VAULT_TOKEN=$(kubectl -n splice-system get secrets vault-keys -o json | jq -r '.data."vault-root-token"' | base64 -d)
    nohup kubectl port-forward  $(kubectl get vaultserver/vault -n splice-system -o json | jq -r '.status.vaultStatus.active') 8200:8200 -n splice-system >/dev/null 2>&1 &
    export PORT_FORWARD_PID=$!
    export VAULT_SKIP_VERIFY="true"
    export VAULT_ADDR='https://127.0.0.1:8200'
    sleep 2
    vault kv list secret
}

function disconnect_k8s_vault {

    kill -9 $PORT_FORWARD_PID
    export VAULT_ADDR=https://vault.build.splicemachine-dev.io
    unset VAULT_SKIP_VERIFY
    unset VAULT_TOKEN
    unset PORT_FORWARD_PID
}
