class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.23.0.tgz"
  sha256 "1a83b61830060062fd009c6ce5ec3fa8951a80f1baad8839b7883fdc4d514040"
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
