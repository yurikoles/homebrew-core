class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.50.tar.gz"
  sha256 "f7bacfa9d6a5084735316717342d86c28fd8b746b26747e928806a052932dc84"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6148c5fdb922368217bc55f8387b1aa3ef776fd545257e0619fb8f33b3b3ae7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13c3491c54a56f02c037c78bde6bd7897a1bb331ae7eb41978ae54fae3078d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb4b2fcfb9f2e4086329ddffa89dc1eda2a3e925161eb2e2abc038a84dadb5c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "469805457e2a1daa85f4b2e8ec6af2ab754299abe90715115bd6ada3691a97dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ae4bb69faf98e1c5ca62e2ff2794ab8c814100c719fd8806fad33f64303734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e6fef8713d35423bbf43805952f58142d485aaa00b0cbcfcc5f159077b2ba4"
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
