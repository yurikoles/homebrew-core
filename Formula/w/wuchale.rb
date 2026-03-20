class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.0.tgz"
  sha256 "d1e4b78b7b176c5d3f010e7221d492d6041e676c58ad2b6568dff2dff7924e0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc7e22ae2f0485822d4cf16dbb22df68a905c22162f518e92cc59a588101542f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
