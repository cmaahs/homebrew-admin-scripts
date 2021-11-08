#!/usr/bin/env bash

function connect-k8s-vault {

    FALKOR_ENV=${1-falkor-dev}
    FALKOR_SECRET_PREFIX=${2}
    if [[ -z ${FALKOR_SECRET_PREFIX} ]]; then
        FALKOR_SECRET_PREFIX=${FALKOR_ENV}
    fi
    export VAULT_TOKEN=$(aws --region us-west-2 secretsmanager get-secret-value --secret-id "${FALKOR_SECRET_PREFIX}-vault-token" | jq -r '.SecretString' | base64 -d | jq -r '.root_token')
    nohup kubectl -n vault port-forward svc/vault-active 8200:8200 >/dev/null 2>&1 &
    export PORT_FORWARD_PID=$!
    export VAULT_SKIP_VERIFY="true"
    export VAULT_ADDR='https://127.0.0.1:8200'
    sleep 5
    SECRET_PATH=$(vault secrets list | jq '. | keys' | jq -r '.[]' | grep '\-kv' | sed 's/\///')
    echo "SECRET_PATH: ${SECRET_PATH}"
    vault kv list ${SECRET_PATH}
}

function disconnect-k8s-vault {

    kill -9 $PORT_FORWARD_PID
    unset VAULT_ADDR
    unset VAULT_SKIP_VERIFY
    unset VAULT_TOKEN
    unset PORT_FORWARD_PID
    unset SECRET_PATH
}
