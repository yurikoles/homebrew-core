class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.6.tgz"
  sha256 "d674c00176c70a437c9586d8f2ef7cf825b47bb1ad82bf505e2d9331052f3915"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa541cbfb8ec51165d6b08de023ac6ce236b87c8811c95491210584e776c7e3f"
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
