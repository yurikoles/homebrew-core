class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.1.0.tgz"
  sha256 "f445cc10556c5b16422d4f4fd4e3d208a1491157d28207cf873615def500a478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b528944e349b32adbe5ed03e0ffaf6db770fa5c83654aba873f25f14c360848"
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
