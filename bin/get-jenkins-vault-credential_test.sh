#!/usr/bin/env bash

JENKINS_URL="https://jenkins.build.splicemachine-dev.io/"
JENKINS_USER=$(whoami)
JENKINS_API_TOKEN=$(security find-generic-password -a "${JENKINS_USER}" -s "build_vault_api_token" -w automation.keychain-db)
# if you have crsp enabled
JENKINS_CRUMB=$(curl -s 'http://${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
if [[ -z ${JENKINS_CRUMB} ]]; then
    JENKINS_CRUMB=" "
fi
 
    curl -s -X GET \
        --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" -H "${JENKINS_CRUMB}" \
        "$JENKINS_URL/credentials/store/system/domain/_/credential/jenkins_vault_test/config.xml"
