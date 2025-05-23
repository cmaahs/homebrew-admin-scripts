#!/usr/bin/env bash

VT=$(vault token create -orphan -policy=jenkins_read -use-limit=99999999999 -ttl 240h -display-name="Jenkins Job Token" | jq -r '.auth.client_token')
echo ${VT}
vault kv put secret/team/vault_jenkins token="${VT}"
 
JENKINS_URL="https://jenkins.build.splicemachine-dev.io/"
JENKINS_USER=$(whoami)
JENKINS_API_TOKEN=$(security find-generic-password -a "${JENKINS_USER}" -s "build_vault_api_token" -w automation.keychain-db)
# if you have crsp enabled
JENKINS_CRUMB=$(curl -s 'http://${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
if [[ -z ${JENKINS_CRUMB} ]]; then
    JENKINS_CRUMB=" "
fi
 
# TODO: TEST This code.  This was manually updated on 2020-09-04 when the credential expired.  This needs to be tested upon the next expiration.
# update Jenkins Credential
TMPFILE=$(mktemp -t jenkins_vault) && {
    # The TMPFILE has been created, we can work with it here.
    # get the credential and replace the token value
    curl -s -X GET \
        --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" -H "${JENKINS_CRUMB}" \
        "$JENKINS_URL/credentials/store/system/domain/_/credential/jenkins_vault/config.xml" | sed "s|<secret-redacted/>|${VT}|" > ${TMPFILE}
    # submit the new credential
    curl -X POST \
        --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
        -H "${JENKINS_CRUMB}" \
        -H 'content-type:application/xml' \
        -d @${TMPFILE} \
        "$JENKINS_URL/credentials/store/system/domain/_/credential/jenkins_vault/config.xml"
    rm -f $TMPFILE
}
