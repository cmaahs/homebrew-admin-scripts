class GetKubectlclient < Formula
  desc "This script fetches the latest Kubectl client that matches the cluster you are connected to, and replaces the /usr/local/bin/kubectl symlink"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.3"

  def install
    bin.install "bin/get-kubectlclient"
    bin.install "bin/get-kubectlversion"
  end

  test do
    system bin/"get-kubectlclient", "--help"
  end
end
