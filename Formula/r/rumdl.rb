class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "7b2c1abf8992d3470cb975754acc7c3913dd5ee9b46a4f833aa90393b0579bce"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d95532b6bb392cffe2b66a2d45266f2f37df242106c350a1b7d46bd514def45a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0e7701c1bb867be4a8539b39f676d4491621d8639d0e5a2e2cbe558979391b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db6197073ec08a8d2fa1228309de686992568270610af8d653e8e45098a7c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c482f593153034280cc451a03cbfbbad2be3ce4246e84b8f7e8788b764e56c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e051c1b6362830afbab033c115732d5f6ae92eb965b58c6a85227e48eb3d3400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908f47599c995664060002b3f6b7667a72922fe177c867f49222660e0576e4e7"
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
