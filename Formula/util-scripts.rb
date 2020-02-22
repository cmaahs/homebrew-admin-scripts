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
  end

end
