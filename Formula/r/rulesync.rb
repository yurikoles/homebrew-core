class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.22.0.tgz"
  sha256 "235eb600306563e6c984bde2a267cae7b5de659a0c5cc010878b7c0c7e996ab2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bf4434a76da2cc24e767376807d2eaebab9c06aaaea2f1a4aa1a4859156714a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
