function switch-vault {

local WHICH_VAULT=$1

if [[ -z ${WHICH_VAULT} ]]; then
  WHICH_VAULT=build
fi


echo "Switching to ${WHICH_VAULT}"
export VAULT_ADDR=$(security find-generic-password -l "${WHICH_VAULT}_vault_addr" -w automation.keychain-db)
export VAULT_TOKEN=$(security find-generic-password -l "${WHICH_VAULT}_vault_token" -w automation.keychain-db)
env | grep VAULT | grep -v TOKEN
echo -n "Value in secret/vaultname: "
vault kv get secret/vaultname | jq -r '.data.data.value'
}
