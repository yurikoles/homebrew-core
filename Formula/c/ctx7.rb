class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.3.12.tgz"
  sha256 "8714192946d6db7f008d1a3a70a9b2d21d3978722a3903a57517dd5d7e22731c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b587b5cd296d4d85c15755a022a9186d66c8872444790907c405b11d6ca37ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ctx7", "setup", "--cli", "--claude", "--yes", "--api-key", "ctx7sk_test_key"

    credentials = JSON.parse((testpath/".context7/credentials.json").read)
    assert_equal "ctx7sk_test_key", credentials["access_token"]
    assert_path_exists testpath/".claude/skills/find-docs/SKILL.md"

    assert_match "find-docs", shell_output("#{bin}/ctx7 skills list")

    assert_match "Invalid API key",
      shell_output("#{bin}/ctx7 library react hooks 2>&1", 1)
  end
end
