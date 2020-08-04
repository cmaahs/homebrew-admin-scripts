class GkeAlias < Formula
  desc "gke-alias is a tool for setting aliases for Kube Config contexts"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.1"
  revision 1

  if OS.mac?
    def install
      bin.install "bin/darwin/gke-alias"
    end
  elsif OS.linux?
    def install
      bin.install "bin/linux/gke-alias"
    end
  end

end
