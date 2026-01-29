class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.6.0.tgz"
  sha256 "3b6ad6576dc0df54882c79bdc70d2dc22d5051e60404d9998e8a357b3c113672"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8e215a9b5ddbd109bc19e1b11ab8562a76228e65ff38b1fa76039adb01595af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
