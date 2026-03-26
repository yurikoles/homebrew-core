class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1114.0.tgz"
  sha256 "7ce9b4b68f4d01cdcf2756463525e9d3bc6ce8627454c0fd41c190f68ad0e2a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8058ccc1df35e04015481113684343fbd64be6604b999385772129253003775c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
