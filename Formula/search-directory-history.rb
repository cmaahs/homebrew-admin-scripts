class SearchDirectoryHistory < Formula
  desc "search-directory-history utility for searching Oh-My-Zsh plugin directory history files"
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.0.2"

  if OS.mac?
    def install
      bin.install "bin/darwin/search-directory-history"
    end
  elsif OS.linux?
    def install
      bin.install "bin/linux/search-directory-history"
    end
  end

end
