class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.3.tgz"
  sha256 "476e71ae5341322b7c0232eb8257b3b03f23b9840641cab99b7f93134af7870a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca988d694d33446db5f528d31d91c953ee2ddb94027bc3696024ef0fffdcfd6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
