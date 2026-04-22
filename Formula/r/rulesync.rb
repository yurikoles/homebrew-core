class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.5.0.tgz"
  sha256 "c4a912518c581e55153c525ba8efff1c6871140a36f5dcfc754e765ebead3697"
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
