class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.80.tar.gz"
  sha256 "37c020e396f53302e887b04d37b3ddb7cc3668a71854149abdd4cb9dfd0332f5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b42f86b42412e205d68e83c8665ea353c869592b81ff8151320624a751c1f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67946e08bedea5e8b94cf20a3643451ebe791a3d8d7a331800e4873f2048f8a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf83448abf70a7bfd098c8897150f61fa2216260d7f95679fb45bc2d4eba323"
    sha256 cellar: :any_skip_relocation, sonoma:        "41212e877c83e10c7d899c8f0408478fa494f34cf395a5460f5b9a9749e795ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a32fbec4fa2d90d20f56ebeaf90c583d01f3bcfa4f01c7418b13a0b1ee251d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b86a73d3dbc937ccc4d7ea18c4fe6fc9fc75c86919a58f0e883937f2c260dc20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
