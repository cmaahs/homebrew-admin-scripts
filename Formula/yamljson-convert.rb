class YamlJsonConvert < Formula
  desc "This will download and install yaml2json/json2yaml from bronze1man repository."
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.1.3"

  def install
    bin.install "bin/get-jsonyamlconvert"
  end
  test do
    system bin/"get-jsonyamlconvert"
  end
  def caveats; <<~EOS
    The script "get-jsonyamlconvert" has been installed and run.  
    This script creates /usr/local/bronze1man/{version}/ directory and symlinks
    are added to /usr/local/bin to both yaml2json and json2yaml applications.
  EOS
  end
end
