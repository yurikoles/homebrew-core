class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "5d5adddde3e265c9783243f57d1b3fb4a928a78c82c229c877961d27ddd31f0a"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "269d3cfa051465882b529d28ad7f96fafcc5d1b64edcb999581ad7c089edd6b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68cce2c63dc9a3d524840cf2d55002e3aab20acf24437932e44ff2859d87671a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1604408da724d64660ecdf4e2feacb3c22a28f85318106b3f27954045ebd208d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fc280f47d54338acc7e9c8c7ee6ca5cd84769b0366fddba1f446efa8809827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3c35ea8a17564c543806f812c5f1aa97f21be99bccd37cd0699b810bfb29f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb5e71e4050bf4f92e568aafd4b9ee39142022050c8ff787a2547027e8703b3"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
