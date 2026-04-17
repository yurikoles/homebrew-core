class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1118.1.tgz"
  sha256 "9128ef9479e35b5b98a6f0e918b0867664e8f9d0d5802e384d3489088f38c196"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a19f2525f22af45b61edde5d648c792993f2048af0ae973416b598efee68c10"
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
