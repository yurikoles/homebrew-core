class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1376.6.tar.gz"
  sha256 "962f38334e08ee96bfe166f5c4b4ade30b470fc7138af9cd14b054c101ddc8ec"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dabb64e14892221962e5884470922b8511558161e433ff1d3cafa7a2a6555726"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
