class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "542273594c1cfd9cbb238cb5f65e6f94ae16cbd6d7ec91edd2386118ee3c0e80"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b64689878e8ed0d0e4808cfbfa014b64327d68b30663af9d053daacf1bf5c126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a3c019cc5db7f0aafae031da1e2fa56d5c1ab65763f28ef0ef869d4a705593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f3264c81ed7bd4cb58f10345f24da879f1b66dee4776c79710d6b20f342e71"
    sha256 cellar: :any_skip_relocation, sonoma:        "77422ada056e810643fc77ab544fcbbea24e6bb65a9138defa2ea9c9d71b0776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "697e90d6ea8d0b2af54d2ef0a235ee2d3920f5f597c599e3cf1d81ebe814b670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac09f9ddf7a5053a238dafb85e34922010ff0768e2b371f4e5e49034f3d29e1"
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
