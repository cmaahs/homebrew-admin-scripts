class UtilScripts < Formula
  desc "This is a collection of general utility scripts"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.1"

  def install
    bin.install "bin/auth-vault"
    bin.install "bin/check-docker-tag"
  end

end
