#!/usr/bin/env bash

JENKINS_URL="https://jenkins.build.splicemachine-dev.io/"
JENKINS_USER=$(whoami)
JENKINS_API_TOKEN=$(security find-generic-password -a "${JENKINS_USER}" -s "build_vault_api_token" -w automation.keychain-db)
AKS_ENVIRONMENT=("pd:eks-dev1 pd:eks-dev2")

for AKS_ENV in ${AKS_ENVIRONMENT}; do
IFS=':' read -r -a ENV_INFO <<< "${AKS_ENV}"
echo "Starting the DESTROY job for ${ENV_INFO[0]}-${ENV_INFO[1]}"
curl -X POST "${JENKINS_URL}/job/Kubernetes/job/KubernetesDeploy/job/aws/job/master/build" \
  --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
  --data-urlencode json="{\"parameter\": [{\"name\":\"account\", \"value\":\"${ENV_INFO[0]}\"}, {\"name\":\"action\", \"value\":\"destroy\"}, {\"name\":\"environment\", \"value\":\"${ENV_INFO[1]}\"}, {\"name\":\"destroy_confirmation\", \"value\":\"${ENV_INFO[1]}\"}, {\"name\":\"kubernetes_version\", \"value\":\"1.14\"}, {\"name\":\"enable_cloud_manager\", \"value\":\"true\"}, {\"name\":\"enable_tick\", \"value\":\"false\"}, {\"name\":\"enable_elastic_stack\", \"value\":\"false\"}, {\"name\":\"CoreNodeInstanceType\", \"value\":\"m5.xlarge\"}, {\"name\":\"CoreNumberOfNodes\", \"value\":\"1\"}, {\"name\":\"CoreMaxNumberOfNodes\", \"value\":\"3\"}, {\"name\":\"DbNodeInstanceType\", \"value\":\"m5.4xlarge\"}, {\"name\":\"DbNumberOfNodes\", \"value\":\"1\"}, {\"name\":\"DbMaxNumberOfNodes\", \"value\":\"12\"}, {\"name\":\"tag_creator\", \"value\":\"Christopher Maahs\"}]}"
sleep 5
done
