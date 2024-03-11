class UtilScripts < Formula
  desc "This is a collection of general utility scripts"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.115"

  def install
    bin.install "bin/check-docker-tag"
    bin.install "bin/bash_256.sh"
    bin.install "bin/bash_color_ls.sh"
    bin.install "bin/bash_colors.sh"
    bin.install "bin/color.zsh"
    bin.install "bin/colorgrid.sh"
    bin.install "bin/k8s-vault-functions.sh"
    bin.install "bin/k8s_creds_functions.sh"
    bin.install "bin/k8s_postgres_functions.sh"
    bin.install "bin/k8s_kubeconfig_functions.sh"
    bin.install "bin/update-az-dns"
    bin.install "bin/otp"
    bin.install "bin/otp_basic"
    bin.install "bin/switch_jira.sh"
    bin.install "bin/create_aws_environments.sh"
    bin.install "bin/create_azure_environments.sh"
    bin.install "bin/create_dns_yaml.sh"
    bin.install "bin/date_functions.sh"
    bin.install "bin/destroy_aws_environments.sh"
    bin.install "bin/destroy_azure_environments.sh"
    bin.install "bin/get-jenkinsjobs"
    bin.install "bin/get-terraformversion"
    bin.install "bin/get-operator-sdk"
    bin.install "bin/kurls-source.sh"
    bin.install "bin/launch-splicectl-api.sh"
    bin.install "bin/ls-window-title"
    bin.install "bin/mk-window-title"
    bin.install "bin/mk-jira-window-title"
    bin.install "bin/rm-window-title"
    bin.install "bin/k8s_list_environments.sh"
    bin.install "bin/log-path.sh"
    bin.install "bin/iterm-set-titles.sh"
    bin.install "bin/roll_version.sh"
    bin.install "bin/order-manifest.ps1"
    bin.install "bin/split-manifest.ps1"
    bin.install "bin/prstat"
    bin.install "bin/sqlshell_functions.sh"
    bin.install "bin/vault_functions.sh"
    bin.install "bin/new-bash-script"
    bin.install "bin/get-gke-versions"
    bin.install "bin/get-jsonui"
    bin.install "bin/worktree_functions.sh"
    bin.install "bin/git_functions.sh"
    bin.install "bin/new-retro"
    bin.install "bin/new-hackathon"
    bin.install "bin/start-bind9"
    bin.install "bin/stop-bind9"
    bin.install "bin/get-github-pat"
    bin.install "bin/get-gitlab-api-pat"
    bin.install "bin/helm_ecr_functions.sh"
    bin.install "bin/bw_functions.sh"
    bin.install "bin/bash_functions.sh"
    bin.install "bin/git-fetch-status-pull"
    bin.install "bin/gcp_functions.sh"
    bin.install "bin/gcp-switch-account"
    bin.install "bin/get-riverlevels"
    bin.install "bin/river-prompt"
    bin.install "bin/show-riverlevels"
    bin.install "bin/vim_multi_commands.sh"
    bin.install "bin/wezterm-shell-interactions.sh"
    bin.install "bin/get-helmversion"
    bin.install "bin/get-ktroubleversion"
    bin.install "bin/get-kubectlversion"
    bin.install "bin/get-teleportversion"
    if OS.mac?
      def install
        bin.install "bin/vault-token-to-clipboard"
      end
    end
  end

  def caveats; <<~EOS
    The use of k8s-vault-functions.sh, k8s_cred_functions.sh, sqlshell_functions.sh,
    and switch_vault.sh all require a "source {script.sh}" line in the startup
    profiles, .bashrc/.zshrc
      git_functions.sh contains the following functions:
        - git-add-modified
        - config-add-modified
          * used to add all the "modified" files, config is the dotfiles alias
      gcp_functions.sh contains teh following functions:
        - gcp-switch-project
          * used to switch projects using an ENV variable
      vim_multi_commands.sh contains th following functions:
        - vi-all-extension
          * used to edit ALL items of a single extension, recursively
      sqlshell_functions.sh contains the following function:
        - connect-sqlshell
      k8s-vault-function.sh contains the following functions:
        - connect_k8s_vault
        - disconnect_k8s_vault
      k8s_cred_functions.sh contains the following functions:
        - get-aws-creds
        - get-az-creds
        - get-gcp-creds
        k8s_list_environments.sh contains the following functions:
        - get-aws-environments
        - get-az-environments
        - get-gcp-environments
        vault_functions.sh contains the following function:
        - switch-vault
        - auth-vault
        switch_jira.sh contains the following function:
        - switch-jira
      otp and otp_basic are used with oauth-toolkit
        - otp uses hasicorp vault or mac os keyring for sensitive data storage
        - otp_basic stores sensitive data in ~/.otpkeys
          - if you choose otp_basic, just re-link /usr/local/bin/otp to the otp_basic version.
      iterm-set-titles.sh contains the following functions:
        - set-title-window
        - set-title-tab
        - set-tab-title-pwd
      worktree_functions.sh contains the following functions:
        - mkwt <branchname> (branchname needs to be in the form of JIRANUM/description)
        - cdwt (prompts for a worktree to change to)
        - cdwtp (changes to the parent git directory)
        - rmwt (prompts for a worktree to remove, and prompt to remove empty parent)
  EOS
  end
end

