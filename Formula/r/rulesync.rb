class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.6.0.tgz"
  sha256 "f6616e758bce33117df4164bc30a5cf837414865a30b51cd22a236aec6b3a01d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f375079d0d1c533830734a7c2b52f6bbda2e8f39423e0449b3600c53a61e33e5"
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
