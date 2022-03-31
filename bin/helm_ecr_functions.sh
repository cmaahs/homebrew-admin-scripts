helm-login-ecr () {
  export HELM_EXPERIMENTAL_OCI=1
  local AWS_ACCOUNT_ALIAS=$(aws iam list-account-aliases | jq -r '.AccountAliases[0]')
  if [[ "${AWS_ACCOUNT_ALIAS}" =~ "core-shared-services" ]]; then
    local REGISTRY_ID=$(aws ecr describe-registry | jq -r '.registryId')
    if [[ -n "${REGISTRY_ID}" ]]; then
      local REGISTRY=${REGISTRY_ID}.dkr.ecr.us-west-2.amazonaws.com
      local LOGIN_PASSWORD=$(aws ecr get-login-password)
      echo "Authenticating to ${REGISTRY}"
      helm registry login ${REGISTRY} --username AWS --password ${LOGIN_PASSWORD}
    else
      echo "Could not determine the registry id"
    fi
  else 
    echo "Your AWS profile is not pointing to a core-shared-services account"
  fi
}
