class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.23.1.tgz"
  sha256 "d580f613942afcf94d94969933353c50b37228a831b85c936569ec1c7a8ad2c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49c0e2206032d4720b1418336b292a59bf29257bcf6405c4f4952aacb41fe8bb"
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
