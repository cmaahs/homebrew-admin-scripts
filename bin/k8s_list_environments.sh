function get-az-environments {
  az aks list | jq '.[].name'
}

function get-aws-environments {

  local REGION=${1-us-east-1}

  local ENVS=("build" "cs" "nonprod" "pd" "prod" "qa" "sales")
  for e in ${ENVS}; do
    # local MFA_CMD="mfa_splice-${e}"
    local PROFILE="splice-${e}"
    # $MFA_CMD
    echo "---- ${e} ----"
    aws eks --region ${REGION} --profile ${PROFILE} list-clusters | jq -r '.clusters'
  done

}


function get-gcp-environments {
  CURRENT_PROJECT=$(gcloud config get-value project)
  for p in $(gcloud projects list --format='value(projectId)'); do
    if [[ "${p}" == *-gke ]]; then
      gcloud config set project ${p} > /dev/null 2>&1
      echo "---- ${p} ----"
      gcloud container clusters list --format='value(name,zone,resourceLabels.creator)'
    fi
  done
  gcloud config set project ${CURRENT_PROJECT} > /dev/null 2>&1
}
