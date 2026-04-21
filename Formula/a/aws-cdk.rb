class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1118.3.tgz"
  sha256 "d5d407850238435d8aa40ed394100106cfbfc4c35a68e47e2f2bc54721b65f9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8266922eff3fd65881f26c0deaa0e32dd8b4281f4cc7dcc55c526052c5bfa6fa"
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
