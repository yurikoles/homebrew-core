class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.5.1.tgz"
  sha256 "ee03e9e48b2efd337409267421ec57987a9e7f8ca67983f4f38e5fa3644e596c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ea6897776133b625c3ad9bb411d95101357eb078dc1e16532c2f2afb3210ab5"
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
