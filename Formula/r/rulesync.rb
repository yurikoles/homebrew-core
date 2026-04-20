class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.4.0.tgz"
  sha256 "4e4d14dade00f1116080c5c7e56549aeef26d2ac6a5d7baff87e7a03f60e53e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1dc837afd61fe4d7870a1cb11389abb3cd19140cbe8021186c3fcf62fea1b832"
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
