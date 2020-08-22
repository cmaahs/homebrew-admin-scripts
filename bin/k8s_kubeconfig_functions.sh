#!/usr/bin/env bash

function set-default-configfile {
	echo ${1} > ~/.kubeconfig_default
}

function apply-default-configfile {
	export KUBECONFIG=~/.kube/config.$(cat ~/.kubeconfig_default)
}
