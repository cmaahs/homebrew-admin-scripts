#!/usr/bin/env bash

JENKINS_URL="https://jenkins.build.splicemachine-dev.io/"
JENKINS_USER=$(whoami)
JENKINS_API_TOKEN=$(security find-generic-password -a "${JENKINS_USER}" -s "build_vault_api_token" -w automation.keychain-db)
AKS_ENVIRONMENT=("aks-dev5 aks-dev6")

for AKS_ENV in ${AKS_ENVIRONMENT}; do
curl -X POST "${JENKINS_URL}/job/Kubernetes/job/KubernetesDeploy/job/azure/job/master/build" \
  --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
  --data-urlencode json="{\"parameter\": [{\"name\":\"action\", \"value\":\"destroy\"}, {\"name\":\"environment\", \"value\":\"${AKS_ENV}\"}, {\"name\":\"destroy_confirmation\", \"value\":\"${AKS_ENV}\"}, {\"name\":\"kubernetes_version\", \"value\":\"1.14.8\"}, {\"name\":\"enable_cloud_manager\", \"value\":\"true\"}, {\"name\":\"enable_tick\", \"value\":\"false\"}, {\"name\":\"enable_elastic_stack\", \"value\":\"false\"}, {\"name\":\"core_vmsize\", \"value\":\"Standard_D4s_v3\"}, {\"name\":\"core_vmcount\", \"value\":\"1\"}, {\"name\":\"core_max_vmcount\", \"value\":\"3\"}, {\"name\":\"db_vmsize\", \"value\":\"Standard_D16s_v3\"}, {\"name\":\"db_vmcount\", \"value\":\"1\"}, {\"name\":\"db_max_vmcount\", \"value\":\"12\"}, {\"name\":\"tag_creator\", \"value\":\"Christopher Maahs\"}]}"
sleep 5
done


