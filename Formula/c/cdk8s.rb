class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.2.tgz"
  sha256 "04e34829c388651864181587a4540ba2885ba25d832f25588ae794d38883d19e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fa9fa2197f6f7ec6f4015a7eeba8294b3c7679910d5ef7b2c908ddb51f15669"
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
