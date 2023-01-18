#!/usr/bin/env zsh

function gitlab-show-cicd-variables() {

  if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "MUST set the GITLAB_TOKEN variable to your personal access token"
    false; return
  fi

  local project_path=${1}
  if [[ -z ${project_path} ]]; then
    echo "MUST Supply a gitlab PATH: 'futurama/bender/gcp/provisioning/lowers/dev-cp-cluster"
    false; return
  fi
  gitlab-export-cicd-variables ${project_path} false

}
function gitlab-export-cicd-variables() {

  if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "MUST set the GITLAB_TOKEN variable to your personal access token"
    false; return
  fi

  local project_path=${1}
  if [[ -z ${project_path} ]]; then
    echo "MUST Supply a gitlab PATH: 'futurama/bender/gcp/provisioning/lowers/dev-cp-cluster"
    false; return
  fi
  local export_vars=${2:-true}

  groups=(${(@s:/:)project_path})

  group_path=""
  for g in ${groups}; do
    if [[ -n ${group_path} ]]; then
      group_path="${group_path}%2F${g}"
    else
      group_path="${group_path}${g}"
    fi
    echo "Looking up path: ${group_path}"
    GROUP_ID=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/groups/${group_path}" | jq -r '.id')
    if [[ "${GROUP_ID}" != "null" ]]; then
      VARIABLES=($(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/groups/${GROUP_ID}/variables" | jq -r '.[] | select(.variable_type=="env_var").key'))
      if [[ -n ${VARIABLES} ]]; then
        for v in ${VARIABLES}; do
          VAR_DATA=$(gitlab-get-group-variable ${v} ${group_path})
          if [[ -n ${VAR_DATA} ]]; then
            if [[ ${export_vars} == true ]]; then
              echo "Exporting ${v}"
              export ${v}=${VAR_DATA}
            else
              echo "${v}"
            fi
          fi
        done
      fi
    else
      local PROJECT_ID=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/projects/${group_path}" | jq -r '.id')
      if [[ "${PROJECT_ID}" != "null" ]]; then
        VARIABLES=($(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/projects/${PROJECT_ID}/variables" | jq -r '.[] | select(.variable_type=="env_var").key'))
        if [[ -n ${VARIABLES} ]]; then
          for v in ${VARIABLES}; do
            VAR_DATA=$(gitlab-get-project-variable ${v} ${group_path})
            if [[ -n ${VAR_DATA} ]]; then
              if [[ ${export_vars} == true ]]; then
                echo "Exporting ${v}"
                export ${v}=${VAR_DATA}
              else
                echo "${v}"
              fi
            fi
          done
        fi
      fi
    fi
  done

}

function gitlab-get-group-variable() {

  if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "MUST set the GITLAB_TOKEN variable to your personal access token"
    false; return
  fi

  local variable_name=${1}
  local group_path=${2}

  local GROUP_ID=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/groups/${group_path}" | jq -r '.id')
  if [[ "${GROUP_ID}" == 0 ]]; then
    echo "ERROR: group not found"
    false; return
  fi
  local VAR_DATA=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/groups/${GROUP_ID}/variables/${variable_name}" | jq -r '.value')
  printf '%s' "${VAR_DATA}"
  true; return
}
function gitlab-get-project-variable() {

  if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "MUST set the GITLAB_TOKEN variable to your personal access token"
    false; return
  fi

  local variable_name=${1}
  local project_path=${2}

  local PROJECT_ID=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/projects/${project_path}" | jq -r '.id')
  if [[ "${PROJECT_ID}" == 0 ]]; then
    echo "ERROR: project not found"
    false; return
  fi
  local VAR_DATA=$(curl -Ls --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://git.alteryx.com/api/v4/projects/${PROJECT_ID}/variables/${variable_name}" | jq -r '.value')
  printf '%s' "${VAR_DATA}"
  true; return
}

function gitlab-get-variable() {

  if [[ -z ${GITLAB_TOKEN} ]]; then
    echo "MUST set the GITLAB_TOKEN variable to your personal access token"
    false; return
  fi

  local variable_name=${1}
  local project_path=${2}
  pp_encoded=$(echo ${project_path} | sed 's/\//%2F/g')

  OUT_DATA=$(gitlab-get-group-variable ${variable_name} ${pp_encoded})
  if [[ $? -ne 0 ]]; then
    OUT_DATA=$(gitlab-get-project-variable ${variable_name} ${pp_encoded})
    if [[ $? -ne 0 ]]; then
      echo "ERROR: the variable was not found on that path"
    fi
  fi

  printf '%s' "${OUT_DATA}"

}

