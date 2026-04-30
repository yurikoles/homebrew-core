class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.14.0.tgz"
  sha256 "cfb462b8370ea3573a70e62d792398aca8cdc94a2b11ab29b8821e9eee81e50e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ad5a6d7876751b72ca0c4c8263e92dda3e6927a20875dc170e7940ce8127fdf"
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
