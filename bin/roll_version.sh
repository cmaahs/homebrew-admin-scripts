#!/bin/bash

# Upgrade cloud manager in place

usage() { echo "Usage: $0 [-v <DEV_442>]" 1>&2; exit 1; }

while getopts ":v:" o; do
    case "${o}" in
        v)
            v=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${v}" ]; then
    usage
fi

kubectl \
	-n splice-system \
	patch \
	deployment \
	sm-cloudmgr-api \
	-p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"sm-cloudmgr-api\",\"image\":\"docker.io/splicemachine/sm_cloudmgr-api:${v}\"}]}}}}";

kubectl \
	-n splice-system \
	patch \
	deployment \
	sm-cloudmgr-admin \
	-p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"sm-cloudmgr-admin\",\"image\":\"docker.io/splicemachine/sm_cloudmgr-api:${v}\"}]}}}}";

kubectl \
	-n splice-system \
	patch \
	deployment \
	sm-cloudmgr-ui \
	-p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"sm-cloudmgr-ui\",\"image\":\"docker.io/splicemachine/sm_cloudmgr-ui:${v}\"}]}}}}";

kubectl \
	-n splice-system \
	patch \
	deployment \
	sm-cloudmgr-opscenter \
	-p "{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"sm-cloudmgr-opscenter\",\"image\":\"docker.io/splicemachine/sm_cloudmgr-opscenter:${v}\"}]}}}}";


kubectl -n splice-system get rs | grep cloudmgr | awk '{print $1}' | xargs kubectl -n splice-system delete rs;
