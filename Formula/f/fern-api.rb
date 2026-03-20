class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.38.0.tgz"
  sha256 "5fe0417b2c55ee46bac863e6a0257f1addf3392ca6d261184fa6d4b6a85c3866"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9a907aed4a4006573413998194c81911d674ca4be8255e8066e10e67dd4ab24"
    sha256 cellar: :any,                 arm64_sequoia: "aeb75355f0090e95c234341a5cb3350f72325a61a30705e2306333162f5ceb2d"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb75355f0090e95c234341a5cb3350f72325a61a30705e2306333162f5ceb2d"
    sha256 cellar: :any,                 sonoma:        "427720dc1ced4418a244772e7c44262c4e3f4bd1c6af3ca5d3b9e36b5953b0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c31d01f880acdc1e431cc2e3e04b619643777cb62d3751f36deb93e35ad5b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002b2d16fe9ba5e34b82bb2e3ae3b300e89ff38790266fd914d07d2041e775cb"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
