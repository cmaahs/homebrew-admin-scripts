#!/usr/bin/env zsh

function gcp-switch-project {
  FORCE_FETCH=${1-false}

  if [[ "${FORCE_FETCH}" == "true" ]]; then
    PROJ_LIST=$(gcloud projects list --format json | jq -r '.[] | .projectId')
    echo ${PROJ_LIST} > ~/.config/alteryx/futurama/gcp_groups.txt
  else
    if [[ -f ~/.config/alteryx/futurama/gcp_groups.txt ]]; then
      PROJ_LIST=$(cat ~/.config/alteryx/futurama/gcp_groups.txt)
    else
      PROJ_LIST=$(gcloud projects list --format json | jq -r '.[] | .projectId')
      echo ${PROJ_LIST} > ~/.config/alteryx/futurama/gcp_groups.txt
    fi
  fi

  export CLOUDSDK_CORE_PROJECT=$(echo ${PROJ_LIST} | fzf)
}

