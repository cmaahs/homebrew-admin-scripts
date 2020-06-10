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
  gcloud container clusters list --format='value(name)'
}
