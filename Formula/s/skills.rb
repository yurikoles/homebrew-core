class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.5.tgz"
  sha256 "1452fde59d3e5c3c0dd2814c2ce2133c89485d5511328cb9afd9733b6512b2ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2ebd300e6a3107dde486a8cf79dd707710b6a4f28b4846162cadb83bce39a15"
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
