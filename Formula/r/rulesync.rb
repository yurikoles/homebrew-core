class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.12.0.tgz"
  sha256 "9f69bbf4c09c4e1ab44917899b00ec10514a9d0db59a2bf4a1d7ff0420b73b57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fe7ffe43bcdf6b3883b4da13838380398a6e2d85f7bb51b61c480818cccb22c"
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
