class UseEnvScripts < Formula
  desc "This is a tool to switch contexts for Splice Machine K8s clusters"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.1"

  def install
    bin.install "bin/use-env"
  end
end
