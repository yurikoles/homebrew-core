class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.9.0.tgz"
  sha256 "74afdd3a0f93d263cd752564a3af202bc5086eed248facccd5b72b90317ecdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95789de0e0492f353b95d2c95f776b59e3674644e1ec2bafd4b9b18d8150f693"
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
