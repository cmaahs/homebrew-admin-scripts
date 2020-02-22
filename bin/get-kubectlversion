#!/bin/bash
# lrwxr-xr-x  1 cmaahs  staff    55B Apr 13 06:43 /usr/local/bin/kubectl -> /Applications/Docker.app/Contents/Resources/bin/kubectl
KUBECTL_CLIENT=${1:-v1.15.4}

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
  sudo chown ${MY_LOGON}:root /usr/local/kubectl
fi;
if [ ! -d "/usr/local/kubectl/${KUBECTL_CLIENT}" ]; then
  sudo mkdir -p "/usr/local/kubectl/${KUBECTL_CLIENT}"
  sudo wget --quiet -O "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_CLIENT}/bin/${TARGET_OS}/amd64/kubectl"
  if [ -f "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" ]; then
    sudo chmod 775 "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl"
  fi
fi
if [ -f "/usr/local/bin/kubectl" ]; then
  sudo rm "/usr/local/bin/kubectl"
fi
sudo ln -s "/usr/local/kubectl/${KUBECTL_CLIENT}/kubectl" "/usr/local/bin/kubectl"
