class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.5.0.tgz"
  sha256 "44fa1a80364a030f0e59dee214ec7ca22207298f2c09ec88a83835acfa7f13f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbbad7295d920c52f2248f62b9ad83f0cbbc9d4cc1c5362bfa27a88cc3141f2a"
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
