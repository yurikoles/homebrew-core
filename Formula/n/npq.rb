class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.16.4.tgz"
  sha256 "1521818148c518e9628acd0b64498211e722c415f6af822055fb09929ccd1562"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "013a7b3bcf86fbe76d0d33390eb75afff4ea0f3b1ccd39df99c30d19ea478e99"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run")
    assert_match "Package Health - Detected an old package", output
  end
end
