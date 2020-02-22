class GetHelmclient < Formula
  desc "This script fetches the latest Helm client that matches the cluster you are connected to, and replaces the /usr/local/bin/helm symlink"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.2"

  def install
    bin.install "bin/get-helmclient"
  end

  test do
    system bin/"get-helmclient", "--help"
  end
end
