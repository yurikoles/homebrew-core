class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1119.0.tgz"
  sha256 "7159472f31b88a7f42bf60883dc440d9158c90d15c0a12b8570b4fcaac18ac46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e8438acf7a2d9172ec4b67b98ca7c3b9c870e8fc03a56dd1e12f09ecfeb93dd"
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
