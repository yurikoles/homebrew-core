class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.8.0.tgz"
  sha256 "8e5283bf41ffb2e681c9dd2a12ce67d1f2cbb95f5c4048bc1afe51804e7f423d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0a26fb22d80112deacc27c894b85216886b4e41c377df1b3c7cfcc4be1395dc"
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
