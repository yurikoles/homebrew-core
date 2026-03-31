class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.7.tgz"
  sha256 "b5445dc88012d8cd8ee513a2ee4d890921ed64dd2bece6c9fee431ea087a4526"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fba176358b5d09b9caf5fe46cdd36b2d5c16d2e093f598a5cff29c18633f58b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
    assert_match "No project skills found", shell_output("#{bin}/skills list")
    system bin/"skills", "init", "test-skill"
    assert_path_exists testpath/"test-skill/SKILL.md"
  end
end
