class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "a39f3918a1d92da62024bf2bb41c0b75ee6bbb174149d7c0b7610dd52f915e16"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a117915578b27cba1ee0ac95b9c92c204c1f9169bb07c630e75122ca8358f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "039a7175b9040dbe54799976b342432abc8115894fba2f4ba87963e0780bf6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "342f0d85e657e75bad882101d21eff43be82415e9de1145b4dd8f2b5c58fbd8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc9097406d52751941d64edda48c2c0036e44828f8b528ee2e0a47547c2f041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1738bc7a721c9fac00041f6a6c7d2a9947ef9acfd9f499be1a083aa00d4a47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b7ba20e1498efab088527c9f518f8eaa66da5b2bd0ba804200ca3cd9270c3a"
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
