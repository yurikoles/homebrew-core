class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.3.tgz"
  sha256 "d6975d78b2671fb28ebc24750db25742349e39ab402dac9998647244c1d615fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98127555fe437ec07797e55b8cd24d98198e51cd23caa180f9df299ef3c0fbc7"
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
