class UtilScripts < Formula
  desc "This is a collection of general utility scripts"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.2"

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
    bin.install "bin/update-az-dns"
    bin.install "bin/kurls"
    bin.install "bin/otp"
    bin.install "bin/switch_vault.sh"
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
      switch_vault.sh contains the following function:
        - switch-vault
  EOS
  end
end
