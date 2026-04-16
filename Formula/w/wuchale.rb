class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.11.tgz"
  sha256 "bc3584b00aae29b201c0a7b397421daff33a7cc50288dee13a21f8b3247f2099"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f9954f69f6f33caae3348ceb8641634b00af278b4778e78b1cea628fd1a7ed5"
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
