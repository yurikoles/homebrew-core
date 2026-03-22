class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.11.0.tgz"
  sha256 "42a01afce2a012d6f20073df4098e51eccd4845f152b8e59d7e8b71e0012f833"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1afcca9e45a59a6e150218cad1239d8e525f7edecdb88ff4eb0585b3b11174ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1afcca9e45a59a6e150218cad1239d8e525f7edecdb88ff4eb0585b3b11174ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afcca9e45a59a6e150218cad1239d8e525f7edecdb88ff4eb0585b3b11174ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d24c059d359117d10e108726de4ee593a447d69b7bef8f44612dbb687f058bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364a99bca0225cff1966a190cd08fad26560bf7a23bf221733d223d39a26d720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1c725f2ab491cad57c9daeb679f6ad3fb4e5dc5b6ececa87c6e9aec877e519"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
