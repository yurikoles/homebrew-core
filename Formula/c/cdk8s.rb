class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.2.tgz"
  sha256 "07da9d68eed1e0bcf9b486cdf007dbe631b2cd8d2eccef1ea6cf27be7552ed29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8442c2a9b731ccaa9e72fb5984b73a8b1f472de3d5729f735bd2beb95aec46c0"
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
