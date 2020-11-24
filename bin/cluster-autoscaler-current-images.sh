#!/usr/bin/env zsh

# clone 'gh repo clone kubernetes/autoscaler' somewhere.
# change to the "somewhere" directory.
cd ~/src/autoscaler
git fetch
git pull

RELEASES=($(gh release list | grep "cluster-autoscaler-1\.[14|15|16|17|18|19]" | grep -v "Pre-release" | awk '{print $4}' | sort))

for r in ${RELEASES}; do
  case ${r} in
    *14*)
      KV14=$(gh release view ${r} | grep 'us.gcr.io' | awk '{ print $2 }' |  tr -d '\r')
      ;;
    *15*)
      KV15=$(gh release view ${r} | grep 'k8s.gcr.io')
      ;;
    *16*)
      KV16=$(gh release view ${r} | grep 'k8s.gcr.io')
      ;;
    *17*)
      KV17=$(gh release view ${r} | grep 'k8s.gcr.io')
      ;;
    *18*)
      KV18=$(gh release view ${r} | grep 'k8s.gcr.io')
      ;;
    *19*)
      KV19=$(gh release view ${r} | grep 'k8s.gcr.io')
      ;;
  esac 
done

echo '        if [[ "$KUBERNETES_VERSION" == "1.14" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV14}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"
echo '        elif [[ "$KUBERNETES_VERSION" == "1.15" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV15}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"
echo '        elif [[ "$KUBERNETES_VERSION" == "1.16" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV16}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"
echo '        elif [[ "$KUBERNETES_VERSION" == "1.17" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV17}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"
echo '        elif [[ "$KUBERNETES_VERSION" == "1.18" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV18}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"
echo '        elif [[ "$KUBERNETES_VERSION" == "1.19" ]]; then'
echo "            \$SED_COMMAND -i \"s|REPLACE_IMAGE|${KV19}|\" ./charts/aws-autoscaler/cluster-autoscaler-autodiscover.yaml"

