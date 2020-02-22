#!/bin/bash
# This is the original Docker installed location.  Symlinked to /usr/local/bin/kubectl
# lrwxr-xr-x  1 cmaahs  staff    55B Apr 13 06:43 /usr/local/bin/kubectl -> /Applications/Docker.app/Contents/Resources/bin/kubectl
# 
# This is intended to connect to your current k8s cluster (using the kubectl client you already have) and determine the 
# server version that is running, and ensure that you have the version downloaded, and the client version that matches the 
# server is them symlinked into /usr/local/bin/kubectl.
#
# The storage location for the downloaded client version is /usr/local/kubectl/{version}/
#
# There is a chicken and egg problem with the script, it requires that you have a working kubectl client installed.  Particularly
# running from /usr/local/bin/kubectl, which will be removed and replaced with a symlink.

set -o pipefail

readonly program="$(basename "$0")"
verbose=0

usage() {
  echo "
    This script downloads and selects the matching kubectl client for your attached k8s cluster.
    usage: $program
    options:
      -h, --help                    Show this help.
  " | sed -E 's/^ {4}//'
}

# available flags
while [[ "$1" ]]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    *)
      break
      ;;
  esac
  shift
done

# MacOS = 'darwin', Linux = 'linux', Windows = 'windows'
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  TARGET_OS=linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
  TARGET_OS=darwin
fi

if [ ! -d "/usr/local/kubectl" ]; then
  MY_LOGON=$(whoami)
  echo ${MY_LOGON}
  sudo mkdir -p /usr/local/kubectl
  sudo chown ${MY_LOGON}:admin /usr/local/kubectl
fi;

if which kubectl >/dev/null 2>&1; then
  KUBECTL_SERVER=$(kubectl version --output=json | jq -r .serverVersion.gitVersion)
else
  KUBECTL_CLIENT="v1.15.4"
  if [ ! -d "/usr/local/kubectl/${KUBECTL_CLIENT}" ]; then
    sudo mkdir -p "/usr/local/kubectl/${KUBECTL_CLIENT}"
    sudo wget --quiet -O "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_CLIENT}/bin/${TARGET_OS}/amd64/kubectl"
    if [ -f "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" ]; then
      sudo chmod 775 "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl"
      if [ -f "/usr/local/bin/kubectl" ]; then
        sudo rm "/usr/local/bin/kubectl"
        sudo ln -s "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "/usr/local/bin/kubectl"
      else
        sudo ln -s "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "/usr/local/bin/kubectl"
      fi
    fi
  fi
  if [ -f "/usr/local/bin/kubectl" ]; then
    sudo rm "/usr/local/bin/kubectl"
    sudo ln -s "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "/usr/local/bin/kubectl"
  else
    sudo ln -s "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "/usr/local/bin/kubectl"
  fi
  KUBECTL_SERVER=$(kubectl version --output=json | jq -r .serverVersion.gitVersion)
fi
echo ${KUBECTL_SERVER}
if [[ ! -z "${KUBECTL_SERVER}" ]]; then
  if [ ! -d "/usr/local/kubectl/${KUBECTL_SERVER}" ]; then
    mkdir -p "/usr/local/kubectl/${KUBECTL_SERVER}"
    wget --quiet -O "/usr/local/kubectl/${KUBECTL_SERVER}/kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_SERVER}/bin/${TARGET_OS}/amd64/kubectl"
    if [ -f "/usr/local/kubectl/${KUBECTL_SERVER}/kubectl" ]; then
      chmod 775 "/usr/local/kubectl/${KUBECTL_SERVER}/kubectl"
      if [ -f "/usr/local/bin/kubectl" ]; then
        rm "/usr/local/bin/kubectl"
        ln -s "/usr/local/kubectl/${KUBECTL_SERVER}/kubectl" "/usr/local/bin/kubectl"
      fi
    fi
  fi
  if [ -f "/usr/local/bin/kubectl" ]; then
    rm "/usr/local/bin/kubectl"
  fi
  ln -s "/usr/local/kubectl/${KUBECTL_SERVER}/kubectl" "/usr/local/bin/kubectl"
fi

