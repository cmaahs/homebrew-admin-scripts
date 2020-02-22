function get-az-creds {
  local SPLICE_ENV=${1-:aks-dev1}
  local RG=$(az group show --name ${SPLICE_ENV} | jq -r .name)
  if [[ "${RG}" == "${SPLICE_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      az aks get-credentials --resource-group ${SPLICE_ENV} --name ${SPLICE_ENV} --overwrite-existing --file ~/.kube/config.${SPLICE_ENV} > /dev/null 2>&1
      local KUBECONF=~/.kube/config.${SPLICE_ENV}
      KUBECONFIG="${KUBECONF}"
      export KUBECONFIG
    else
      echo "Failed"
    fi
  fi
}

function get-aws-creds {
  local SPLICE_ENV=${1-eks-dev1}
  local PROFILE=${AWS_PROFILE-splice-nonprod}
  local REGION=${2-us-east-1}

  local CLUSTER=$(aws eks --region ${REGION} --profile ${PROFILE} describe-cluster --name ${SPLICE_ENV} | jq -r .cluster.name)
  if [[ "${CLUSTER}" == "${SPLICE_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      aws eks --region ${REGION} --profile ${PROFILE} update-kubeconfig --name ${SPLICE_ENV} --alias ${SPLICE_ENV} --kubeconfig ~/.kube/config.${SPLICE_ENV} > /dev/null 2>&1
      local KUBECONF=~/.kube/config.${SPLICE_ENV}
      KUBECONFIG="${KUBECONF}"
      export KUBECONFIG
    else
      echo "Failed"
    fi
  fi
}
