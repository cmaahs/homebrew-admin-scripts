function get-az-creds {
  local SPLICE_ENV=${1-aks-dev1}
  local RG=$(az group show --name ${SPLICE_ENV} | jq -r .name)
  if [[ "${RG}" == "${SPLICE_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      az aks get-credentials --admin --resource-group ${SPLICE_ENV} --name ${SPLICE_ENV}-aks --overwrite-existing --file ~/.kube/config.${SPLICE_ENV} > /dev/null 2>&1
      local KUBECONF=~/.kube/config.${SPLICE_ENV}
      chmod 600 ~/.kube/config.${SPLICE_ENV}
      KUBECONFIG="${KUBECONF}"
      export KUBECONFIG
    else
      echo "Failed"
    fi
  fi
}

function get-aws-creds {
  local ALTERYX_ENV=${1-alteryx-sub-highfive-apri-dev}
  local ALTERYX_CLUSTER=${2-high-five-apri-dev-moth}
  local REGION=${3-us-west-2}

  local CLUSTER=$(aws eks --region ${REGION} --profile ${ALTERYX_ENV} describe-cluster --name ${ALTERYX_CLUSTER} | jq -r .cluster.name)
  if [[ "${CLUSTER}" == "${ALTERYX_CLUSTER}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      aws eks --region ${REGION} --profile ${ALTERYX_ENV} update-kubeconfig --name ${ALTERYX_CLUSTER} --alias ${ALTERYX_CLUSTER} --kubeconfig ~/.kube/config.${ALTERYX_CLUSTER} > /dev/null 2>&1
      local KUBECONF=~/.kube/config.${ALTERYX_CLUSTER}
      chmod 600 ~/.kube/config.${ALTERYX_CLUSTER}
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
      chmod 600 ~/.kube/config.${SPLICE_ENV}
    else
      echo "Failed"
    fi
  fi
}
