class Kurls < Formula
  desc "This is a tool to generate URLs for Splice Machine K8s clusters"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.3"

  def install
    bin.install "bin/kurls"
  end
end
