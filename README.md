# homebrew-admin-scripts
Collection of brew installable administrative scripts for making my daily life easier

## Scripts and their respective Formula

### Formula util-scripts

`brew install cmaahs/admin-scripts/util-scripts`

- "bin/auth-vault"
- "bin/bash_256.sh"
- "bin/bash_color_ls.sh"
- "bin/bash_colors.sh"
- "bin/check-docker-tag"
- "bin/color.zsh"
- "bin/colorgrid.sh"
- "bin/k8s-vault-functions.sh"
- "bin/k8s_creds_functions.sh"
- "bin/update-az-dns"
- "bin/kurls"
- "bin/otp"
- "bin/switch_vault.sh"
- "bin/vault-token-to-clipboard"

### Formula docker-ops

`brew install cmaahs/admin-scripts/util-scripts`

- "bin/start-cloudvault"
- "bin/start-cloudops"
- "bin/start-personalops"
- "bin/stop-cloudops"
- "bin/stop-cloudvault"
- "bin/stop-personalops"

### Formula get-kubectlclient

`brew install cmaahs/admin-scripts/get-kubectlclient`

- "bin/get-kubectlclient"
- "bin/get-kubectlversion"

### Formula get-helmclient

`brew install cmaahs/admin-scripts/get-helmclient`

- "bin/get-helmclient"      <- this is specific to helm2, auto matches to tiller version
- "bin/get-helmversion"     <- this can fetch any version

### Formula git-code

Since the release of `gh` command line tool by github.com, I don't use this much anymore

`brew install cmaahs/admin-scripts/git-code`

- "bin/darwin/git-code"
- "bin/linux/git-code"

### Formula search-directory-history

`brew install cmaahs/admin-scripts/search-directory-history`

- "bin/darwin/search-directory-history"
- "bin/linux/search-directory-history"
