class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.6.0.tgz"
  sha256 "ae2f7e031ff37bd7cdfcd745e77bbf19cc7bca1d4c2b56bed276118f8e8cec50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "379fcda16a664e6f7c8f6d97f8286d4976bd8e9d1eb7e8807e791ab52b92b58e"
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
