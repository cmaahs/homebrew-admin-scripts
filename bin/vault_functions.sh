#!/bin/bash

function auth-vault {
  FOUND_PROFILE=0
  FOUND_EXPIRATION=0
  UPDATED_TOKEN=0
  while read LINE
  do
    if [[ "${LINE}" == "[splice-build]" ]] || [[ ${FOUND_PROFILE} -eq 1 ]]; then
      FOUND_PROFILE=1
      if [[ ${LINE} == expiration* ]]
      then
        FOUND_EXPIRATION=1
	FOUND_PROFILE=2
        EXPIRATION_DATE=$(echo ${LINE} | cut -d'=' -f2)
        NOW_SECONDS=$(gdate +%s)
        EXPIRATION_SECONDS=$(gdate +%s -d "${EXPIRATION_DATE}")
        EXPIRES_SECONDS=$(expr ${EXPIRATION_SECONDS} - ${NOW_SECONDS})
        if [ ${EXPIRES_SECONDS} -gt 0 ]
        then
	  echo "Getting new TOKEN..."
          export AWS_PROFILE=splice-build
          AUTH_TOKEN=$(vault login -no-store -method=aws header_value=vault.build.splicemachine-dev.io role=dev-role-iam 2> /dev/null | jq -r '.auth.client_token')
          unset AWS_PROFILE
          echo "Authentication successful"
	  echo "Storing TOKEN in the Automation Keyring"
          NOOUT=$(security add-generic-password -U -a $(whoami) -s "build_vault_token" -w "${AUTH_TOKEN}" automation.keychain-db)
          switch-vault build
          UPDATED_TOKEN=1
        else
          echo "AWS MFA Token HAS already expired"
        fi
      fi
    fi
  done < ${HOME}/.aws/credentials
  if [[ ${FOUND_EXPIRATION} -eq 0 ]]; then
    echo "AWS MFA expiration WAS NOT found"
  fi
  if [[ ${FOUND_PROFILE} -eq 0 ]]; then
    echo "AWS Credentials profile [splice-build] was not in ~/.aws/credentials file"
  fi
  if [[ ${UPDATED_TOKEN} -eq 0 ]]; then
    echo "Unable to update the TOKEN, perhaps the vault server is inaccessible?"
  fi
}

function switch-vault {

  local WHICH_VAULT=$1

  if [[ -z ${WHICH_VAULT} ]]; then
    WHICH_VAULT=build
  fi

  echo "Switching to ${WHICH_VAULT}"
  export VAULT_ADDR=$(security find-generic-password -l "${WHICH_VAULT}_vault_addr" -w automation.keychain-db)
  export VAULT_TOKEN=$(security find-generic-password -l "${WHICH_VAULT}_vault_token" -w automation.keychain-db)
  env | grep VAULT | grep -v TOKEN
  echo -n "Value in secret/vaultname: "
  vault kv get secret/vaultname | jq -r '.data.data.value'
}

function test-jenkins-token {
  export TKLIST_JQFORMAT='(["NAME","EXPIRES"]), (. | ["JENKINS", .data.expire_time])| @tsv'
  export TKLISTNH_JQFORMAT='(. | ["CMAAHS", .data.expire_time])| @tsv'
  export VAULT_TOKEN=$(vault kv get -format=table -field=token secret/team/vault_jenkins)
  JENKINS=$(vault token lookup | jq -r ${TKLIST_JQFORMAT})
  WHICH_VAULT=build
  export VAULT_TOKEN=$(security find-generic-password -l "${WHICH_VAULT}_vault_token" -w automation.keychain-db)
  CMAAHS=$(vault token lookup | jq -r ${TKLISTNH_JQFORMAT})
  echo "${JENKINS}\n${CMAAHS}" | column -t
}

function list-vault-tokens {
  OUT="NAME\tISSUED\tEXPIRES"
  ACCESSORS=($(vault list -format=json auth/token/accessors/ | jq -r '.[]'))
  for a in ${ACCESSORS}; do
    echo "Processing ${a}..."
    TOKINFO=$(vault token lookup -accessor ${a} | jq -r '( . | [.data.display_name, .data.issue_time, .data.expire_time]) | @tsv')
    OUT="${OUT}\n${TOKINFO}"
  done
  echo "${OUT}" | column -t
}
