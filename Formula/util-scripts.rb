class UtilScripts < Formula
  desc "This is a collection of general utility scripts"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.32"

  def install
    bin.install "bin/auth-vault"
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
    bin.install "bin/switch_vault.sh"
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
    bin.install "bin/rm-window-title"
    bin.install "bin/k8s_list_environments.sh"
    bin.install "bin/log-path.sh"
    bin.install "bin/iterm-set-titles.sh"
    bin.install "bin/roll_version.sh"
    bin.install "bin/order-manifest.ps1"
    bin.install "bin/split-manifest.ps1"
    bin.install "bin/prstat"
    if OS.mac?
      def install
        bin.install "bin/vault-token-to-clipboard"
      end
    end
  end

  def caveats; <<~EOS
    The use of k8s-vault-functions.sh, k8s_cred_functions.sh, and switch_vault.sh
    all require a "source {script.sh}" line in the startup profiles, .bashrc/.zshrc
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
        switch_vault.sh contains the following function:
        - switch-vault
        switch_jira.sh contains the following function:
        - switch-jira
      otp and otp_basic are used with oauth-toolkit
        - otp uses hasicorp vault or mac os keyring for sensitive data storage
        - otp_basic stores sensitive data in ~/.otpkeys
          - if you choose otp_basic, just re-link /usr/local/bin/otp to the otp_basic version.
      iterm-set-titles.sh contains the following functions:
        - set-title-window
        - set-title-tab
  EOS
  end
end
