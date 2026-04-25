class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.10.0.tgz"
  sha256 "0eb41c2e2a75f55e4551801113ab473f0f21998cbb86973936dcf923cd66478e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6dec01c930382da505d3b28698cc34ca3c8856184001cbe35e4f31df262d8b3f"
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
