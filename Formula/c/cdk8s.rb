class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.5.tgz"
  sha256 "962dcbaea2099f0f5ba040cf6ba22bafe370d53ff68eeedbcd080f4807ce2c90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7791c4f25ed085e719beaaa17d9a0dc8d4a6462c659609430e08c2e2ad5e9d8"
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
