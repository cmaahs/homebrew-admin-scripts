class DockerOps < Formula
  desc "This is a set of scripts revolving around the startup of local Docker Ops images."
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.3"

  def install
    bin.install "bin/start-cloudvault"
    bin.install "bin/start-cloudops"
    bin.install "bin/start-personalops"
    bin.install "bin/stop-cloudops"
    bin.install "bin/stop-cloudvault"
    bin.install "bin/stop-personalops"
  end

end
