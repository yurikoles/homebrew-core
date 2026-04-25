class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.4.0.tgz"
  sha256 "81def2a592797087de38bb83d4fed8024b927189636fede1bc75243d057b662d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55348e38a50adec4de08330681985151dcc9dc874be39f941a87de362898f369"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
