class UtilScripts < Formula
  desc "git-code utility for searching and cloning company repositories"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.1"

  if OS.mac?
    def install
      bin.install "bin/darwin/git-code"
    end
  elsif OS.linux?
    def install
      bin.install "bin/linux/git-code"
    end
  end

end
