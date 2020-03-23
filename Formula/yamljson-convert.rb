class YamljsonConvert < Formula
  desc "This will download and install yaml2json/json2yaml from bronze1man repository."
  homepage "https://github.com/cmaahs/homebrew-admin-scripts"
  url "https://github.com/cmaahs/homebrew-admin-scripts.git"
  version "0.1.5"

  def install
    bin.install "bin/get-jsonyamlconvert"
  end
  def caveats; <<~EOS
    This brew ONLY installs the script "get-jsonyamlconvert".
    To INSTALL the yaml2json and json2yaml please run:

       /usr/local/bin/get-jsonyamlconvert


    This script creates /usr/local/bronze1man/yaml2json|json2yaml/{version}/ directories
    and symlinks are added to /usr/local/bin to both yaml2json and json2yaml applications.
  EOS
  end
end
