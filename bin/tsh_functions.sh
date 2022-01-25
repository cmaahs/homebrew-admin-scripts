function tsh-connect {
  declare -A endpoints=([teleport.remote-access.falkor.rocks]=teleport.remote-access.falkor.rocks [teleport.remote-access.alteryxcloud.com]=teleport.remote-access.alteryxcloud.com)
  NP_PROD=${1-$(echo ${endpoints} | tr ' ' '\n' | fzf)}
  if [[ -v endpoints[${NP_PROD}] ]]; then
    if tsh status > /dev/null 2>&1; then
      echo "Currently connected, please 'tsh logout' first."
    else 
      tsh login --proxy=${NP_PROD}:443
    fi
  else
    echo "Endpoint specified does not match valid endpoints list:"
    for i in $endpoints; do
      echo "\t${i}"
    done
  fi
}

function tsh-kube-config {
  if tsh status > /dev/null 2>&1; then
    KUBE_CLUSTER=$(tsh kube ls | awk 'NF {print $1}' | fzf --header-lines=2)
    if [[ -f ~/.kube/tsh.${KUBE_CLUSTER} ]]; then
      rm ~/.kube/tsh.${KUBE_CLUSTER}
    fi
    # I may be the only one using per-cluster ~/.kube/<cluster config> files
    # This is to allow a separate Kubernetes cluster context to be set PER terminal session
    # rather than a global context, affecting all terminal sessions
    if [[ "${USERNAME}" == "christopher.maahs" ]]; then
      KUBECONFIG=~/.kube/tsh.${KUBE_CLUSTER}
      export KUBECONFIG
    fi
    tsh kube login ${KUBE_CLUSTER}
    # similarly, I don't like LONG kube cluster names, as they disrupt my command line prompt
    # that displays current-context, which is always right since I'm using PER session KUBECONFIG
    # variables.
    if [[ "${USERNAME}" == "christopher.maahs" ]]; then
      chmod 600 ~/.kube/tsh.${KUBE_CLUSTER}
      CURRENT_CONTEXT=$(yq e '.current-context' ${KUBECONFIG})
      SHORT_CONTEXT=$(echo ${CURRENT_CONTEXT} | cut -d'-' -f4)
      yq e -i ".contexts[] |= select(.name == \"${CURRENT_CONTEXT}\").name=\"${SHORT_CONTEXT}\"" ${KUBECONFIG}
      yq e -i ".current-context = \"${SHORT_CONTEXT}\"" ${KUBECONFIG}
    fi
  else 
    echo "Not currently connected to a TSH proxy, please run 'tsh-connect'"
  fi
}
