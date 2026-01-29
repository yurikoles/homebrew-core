class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9b852bf6568e62b678039c23eab67baf2913bfc1bf0d85d9bff446ba94652155"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e4fde49b92fe0527be2552efd5383f4da1f7c0a6ce4cb1826fb994cae8a15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0ee208f5792755372da9f5f498e89c5a6c88960ee536caefe9deaaeaf431b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f14657a57af8875a2821e3d3a7cad173b7a7dbae71549712d673389ce10bbc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e908fa0faeafdffa69c0031869abe6186b4112e70f84f02b604bbe181d6f5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef74732de66ad185ee43738a86ab43960fdff1273a89d7a8f245c8c062f0c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d79d3dfd459b45951f6ace7423dc36a8ea845746dc2aa069534ef886b4837a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
