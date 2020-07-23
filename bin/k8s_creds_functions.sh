function get-az-creds {
  local SPLICE_ENV=${1-aks-dev1}
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
  local SPLICE_ENV=${1-nonprod-eks-dev1}
  local ENV_SPLIT=("${(@s/-/)SPLICE_ENV}")
  local ENV_ACCT=${ENV_SPLIT[1]}
  local PROFILE="splice-${ENV_ACCT}"
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


function get-gcp-creds {
  local SPLICE_ENV=${1-nonprod-gke-dev1}
  local ENV_SPLIT=("${(@s/-/)SPLICE_ENV}")
  local ENV_ACCT=${ENV_SPLIT[1]}
  local PROJECT="${ENV_ACCT}-gke"

  echo "Setting up: ${SPLICE_ENV}"
  gcloud config set project ${PROJECT} > /dev/null 2>&1
  local CLUSTER=$(gcloud container clusters list --format='value(name)' --filter="name=${SPLICE_ENV}")
  if [[ "${CLUSTER}" == "${SPLICE_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      LOCATION=$(gcloud container clusters list --format='value(location)' --filter="name=${SPLICE_ENV}")
      if [[ -f ~/.kube/config.${SPLICE_ENV} ]]; then
        rm ~/.kube/config.${SPLICE_ENV}
      fi
      local KUBECONF=~/.kube/config.${SPLICE_ENV}
      KUBECONFIG="${KUBECONF}"
      export KUBECONFIG
      gcloud container clusters get-credentials ${SPLICE_ENV} --region ${LOCATION}
      sed -i "/    user:/{N;s/name: .*$/name: ${SPLICE_ENV}/}" ${KUBECONF}
      sed -i "/current-context:/c current-context: ${SPLICE_ENV}" ${KUBECONF}
    else
      echo "Failed"
    fi
  fi
}
