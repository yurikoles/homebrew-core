class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.27.0.tgz"
  sha256 "1257441f94c3ac74ec2c1a603f609ecdef7ece4c59931b961cfd7b3e1194407e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1513c8e01b2374770805340dc723ba234e7944fc194391a1c20826860fd88f0b"
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
