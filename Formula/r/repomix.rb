class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.13.1.tgz"
  sha256 "6cf55ff94ceff076def10159561933be8830f886d058cc7908f3a8951630006f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91b47ff480cbd9387ce4081149b59f7f10eb32e0b52f95c6007fc1c7496b348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91b47ff480cbd9387ce4081149b59f7f10eb32e0b52f95c6007fc1c7496b348"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
