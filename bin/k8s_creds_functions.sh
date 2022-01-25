function get-az-creds {
  local ALTERYX_ENV=${1-aks-mushu}
  local RG=$(az group show --name ${ALTERYX_ENV} | jq -r .name)
  if [[ "${RG}" == "${ALTERYX_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      az aks get-credentials --admin --resource-group ${ALTERYX_ENV} --name ${ALTERYX_ENV}-aks --overwrite-existing --file ~/.kube/config.${ALTERYX_ENV} > /dev/null 2>&1
      KUBECONFIG=~/.kube/config.${ALTERYX_ENV}
      chmod 600 ~/.kube/config.${ALTERYX_ENV}
      export KUBECONFIG
    else
      echo "Failed"
    fi
  fi
}

function get-aws-creds {
  local ALTERYX_ENV=${1-mushu-falkor-rocks}
  local ALTERYX_CLUSTER=${2-a0000000027}
  local REGION=${3-us-west-2}

  local CLUSTER=$(aws eks --region ${REGION} --profile ${ALTERYX_ENV} describe-cluster --name ${ALTERYX_CLUSTER} | jq -r .cluster.name)
  if [[ "${CLUSTER}" == "${ALTERYX_CLUSTER}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      aws eks --region ${REGION} --profile ${ALTERYX_ENV} update-kubeconfig --name ${ALTERYX_CLUSTER} --alias ${ALTERYX_CLUSTER} --kubeconfig ~/.kube/config.${ALTERYX_CLUSTER} > /dev/null 2>&1
      KUBECONFIG=~/.kube/config.${ALTERYX_CLUSTER}
      chmod 600 ~/.kube/config.${ALTERYX_CLUSTER}
      export KUBECONFIG
    else
      echo "Failed"
    fi
  fi
}


function get-gcp-creds {
  local ALTERYX_ENV=${1-gke-mushu}
  local PROJECT=${2-alteryx-mushu}

  echo "Setting up: ${ALTERYX_ENV}"
  gcloud config set project ${PROJECT} > /dev/null 2>&1
  local CLUSTER=$(gcloud container clusters list --format='value(name)' --filter="name=${ALTERYX_ENV}")
  if [[ "${CLUSTER}" == "${ALTERYX_ENV}" ]]; then
    if which kubectl >/dev/null 2>&1; then
      LOCATION=$(gcloud container clusters list --format='value(location)' --filter="name=${ALTERYX_ENV}")
      if [[ -f ~/.kube/config.${ALTERYX_ENV} ]]; then
        rm ~/.kube/config.${ALTERYX_ENV}
      fi
      KUBECONFIG=~/.kube/config.${ALTERYX_ENV}
      export KUBECONFIG
      gcloud container clusters get-credentials ${ALTERYX_ENV} --region ${LOCATION}
      sed -i "/    user:/{N;s/name: .*$/name: ${ALTERYX_ENV}/}" ${KUBECONFIG}
      sed -i "/current-context:/c current-context: ${ALTERYX_ENV}" ${KUBECONFIG}
      chmod 600 ~/.kube/config.${ALTERYX_ENV}
    else
      echo "Failed"
    fi
  fi
}
