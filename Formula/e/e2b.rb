class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.10.1.tgz"
  sha256 "c2fe2bcd23fa1ad040b1d42d6f18a6f8ce8e3135499bd7862a76326852e0fb60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efbac75da5fbc3bd1b2736daa7506230187432dccad1d028b342655deec97ed4"
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
