class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "442b87e36c6cf9de32d55a8397c9b898814525ab252bda0e62b9bfdf805e552c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82f8ca9945ad9e6696cd7bf885f2d94ecb4dbe78b71fec64e1b0c4336f75485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a554aeb8e34c5d77eaf10636c6f0145fadf220956d61ccbcefabd6f5a2dc9491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14814f5be4bc98c9a3db28223ae91bfb0fb66280bd0e14779d6200235e21ae3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f152c63ab333c5f0ff9046d5f3927a57cc24e76d5a0ac0e29d92ed54462c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62de5b0d44401d48947102bd4dd6d5f82e1201e3ebb02f7f98dc3f061e3c5eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac4bcaedcbd92bdd9d4b5d4e50619b302b47bd452d36d3bd55dcdd263b5c5b4"
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
