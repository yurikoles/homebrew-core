class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.75.tar.gz"
  sha256 "2a5dfbce0ba35dbc809558e40103dc0a2480e0b1d9f647abf6c09607caa0d51b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff2f74ce01337e1d0860488c6663601e7d95c00b8afc104040119fffe3901e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5784bfaef83f9e6518b693b7dc71c28208b466f457a2dffa8a0e50ee36e9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "756c97e6a38fc623d4071bf6ca54593bc11192ee626a5e4ebcaba7004eaa13a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a46b210166d85b221147a3c735ba14dca767eb26303062260b32da5074996f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169144efa928481ce5003e84136aef8ea5a15a2d51a70277d517b68027eaa9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857db903e9ddaafe3f0215ba124e713e35fba40ad86a3869cc91c9690579efd6"
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
