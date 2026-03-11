class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.52.0.tar.gz"
  sha256 "e9820997565914c33821c85df4dc5781b96d056b5ad8f5bbc17f2cb8d6d15442"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef44b447f6c6b4c14749d811d06cf9224f38583c779d0bef7b71e31bc1d5fa85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99a6adc3b67892254fa51c894d276c3d89bfbfa3c37bff3d462bde36be85422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da00d53a2c698b3ea18af6788d453cd154608ac97942c0d75fe082706a657310"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4992aa9c6ee13492bebcb7a9018de20c4ed61139dc84128f79e0e58f83d759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2855dab6a80fc647bf8b532e79f1146b6344d2a703fded0084e2ce006e9e1da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ded27ded6a815ff7c7f1fa0138c9f223e8767edc6989d20caa8bac67224806"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
