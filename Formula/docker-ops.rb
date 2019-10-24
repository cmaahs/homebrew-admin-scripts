class DockerOps < Formula
  desc "This is a set of scripts revolving around the startup of local Docker Ops images."
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.1"

  def install
    bin.install "bin/start-cloudvault"
    bin.install "bin/start-cloudops"
    bin.install "bin/start-personalops"
  end

end
