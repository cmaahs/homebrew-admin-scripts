function helm-login-ecr {
export HELM_EXPERIMENTAL_OCI=1
LOGIN_PASSWORD=$(aws ecr get-login-password --region us-west-2)
if [[ "${AWS_PROFILE}" == "core-shared-services" ]]; then
  REGISTRY=712053168757.dkr.ecr.us-west-2.amazonaws.com
else
  REGISTRY=497653049893.dkr.ecr.us-west-2.amazonaws.com
fi
helm registry login ${REGISTRY} --username AWS --password ${LOGIN_PASSWORD}
}
