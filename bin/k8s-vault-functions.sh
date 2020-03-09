#!/usr/bin/env bash

function connect_k8s_vault {

    AWSPROFILE=${AWS_PROFILE:-splice-nonprod}
    CSP=$(kubectl -n default get secret/vault-key-store -o json | jq -r '.data.CLOUD_PROVIDER' | base64 -d)
    vaultname="$(kubectl get secret vault-key-store -o json | jq -r .data.ENVIRONMENT | base64 -d | tr -d '-')vault"
    SPLICE_ENV=$(kubectl get secret vault-key-store -o json | jq -r .data.ENVIRONMENT | base64 -d)
    nohup kubectl port-forward  $(kubectl get vaultserver/vault -n default -o json | jq -r '.status.vaultStatus.active') 8200:8200 -n default >/dev/null 2>&1 &
    export PORT_FORWARD_PID=$!
    export VAULT_SKIP_VERIFY="true"
    export VAULT_ADDR='https://127.0.0.1:8200'
    if [[ "${CSP}" == "aws" ]]; then
      rt_key="$(kubectl get secret vault-key-store -o json | jq -r .data.ENVIRONMENT | base64 -d)vault"
      ENC_TOKEN=$(aws ssm get-parameters --profile ${AWSPROFILE} --with-decryption --names "/k8s/${rt_key}-root-token" | jq -r '.Parameters[0].Value')
      export VAULT_TOKEN=$(aws kms decrypt --profile ${AWSPROFILE} --ciphertext-blob fileb://<(echo "${ENC_TOKEN}" | base64 -d -) --output text --query Plaintext --encryption-context 'Tool=vault-unsealer' | base64 -d -)
    elif [[ "${CSP}" == "az" ]]; then
      export VAULT_TOKEN=$(az keyvault secret show --name "vault-root-token" --vault-name "${vaultname}" | jq -r '.value' | base64 -d)
    elif [[ "${CSP}" == "gcp" ]]; then
      LOCATION=$(gcloud container clusters list --format='value(location)' --filter="name=${SPLICE_ENV}")
      export VAULT_TOKEN=$(gsutil cat "gs://${SPLICE_ENV}-vault-keys/vault-root-token" | gcloud kms decrypt --location ${LOCATION} --keyring ${SPLICE_ENV}-keyring --key ${SPLICE_ENV}-vault-key --ciphertext-file - --plaintext-file -)
    else
      echo "Could not determine ROOT TOKEN"
      exit 1
    fi
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
