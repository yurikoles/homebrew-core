class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.1.0.tgz"
  sha256 "2be96f1f72ef3424f58f5a649079dc68b54e58382b5dfdfc255b7a1aaafe0db8"
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
