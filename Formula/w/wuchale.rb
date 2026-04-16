class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.10.tgz"
  sha256 "6285176d7b15c3372e4c325767f48cf468910746e49d66fb01b06e6daaa61e62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1ed7d26355b6dd87b0cc699fcbf12963420c0f576b62c3eb37cf80195ab8841"
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
