class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.1.1.tgz"
  sha256 "aa96b5c0c5db5fff049699a570de0a61783fd2dbfda6e9ca5668a5bc0ef0d081"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f3ab416e90ecb8f95acffc4bb36f090177a8df2f26153c2eeec1150fa22f6c4"
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
