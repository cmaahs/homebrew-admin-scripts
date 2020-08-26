#!/usr/bin/env bash

function set-default-configfile {
    cat ~/.kubeconfig_default | grep ${ITERM_PROFILE} > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "${ITERM_PROFILE}:${1}" >> ~/.kubeconfig_default
        echo "${ITERM_PROFILE}-12:${1}" >> ~/.kubeconfig_default
    else
        sed -i "/${ITERM_PROFILE}:/c ${ITERM_PROFILE}:${1}" ~/.kubeconfig_default
        sed -i "/${ITERM_PROFILE}-12:/c ${ITERM_PROFILE}-12:${1}" ~/.kubeconfig_default
    fi
}

function apply-default-configfile {
	CONF_NAME=$(cat ~/.kubeconfig_default | grep "${ITERM_PROFILE}:" | sed "s/${ITERM_PROFILE}://")
	if [[ -z ${CONF_NAME} ]]; then
		CONF_NAME=$(cat ~/.kubeconfig_default | grep Default | sed "s/Default://")
	fi
	export KUBECONFIG=~/.kube/config.${CONF_NAME}
}
