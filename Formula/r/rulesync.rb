class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.2.0.tgz"
  sha256 "bd9ea3972b55ee9a58e8493500859368d16c888e85220990a21e24587e5429a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58ca34bf5a9ecd8fa7a266e7fcd1f3d30600333b1868ecfd548d3810b56373d4"
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
