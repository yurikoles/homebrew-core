class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "caac3c1b41b48803a729d4a5f3ef6c045faebeca684ef6b629e182b7d0989125"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7e00d9e0569d958a7b33635e904ed3a5397c426b9e1830d83dbece7c8d6718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56bad2bcee031065ba66759215e57c510a46186260458920f68840fadfef986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0efe9dbac3d7875be4cf0478fa26bdce5c27204b88520603d9b896df427ffba"
    sha256 cellar: :any_skip_relocation, sonoma:        "35cd567c9b4e86bd6e81789ea6016aaa21c12f79b6d06bc2eb2a396ff7cf805d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31d55bb0464fe6dcb62c91916e54f29839f21b1ffeb00fb823b8475abc04493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4cf650013e0e2eac73d4a060df283faced24c7baeb51711eb6c6073b426abb"
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
