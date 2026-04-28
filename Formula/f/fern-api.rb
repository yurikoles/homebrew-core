class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.105.0.tgz"
  sha256 "95f43d39632dd55b15bdc916399e5cce382ebabf7d1b5d2badbc3efc8bd0352b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9af0b39dd429a70d2a07f61e6b29ddf57187dc48e01716aa4b2695053957628d"
    sha256 cellar: :any,                 arm64_sequoia: "b5710bee61d9a4250d4e7d7c9ec052eb1ec81f87d337196d2967bf5f2e03bdc8"
    sha256 cellar: :any,                 arm64_sonoma:  "b5710bee61d9a4250d4e7d7c9ec052eb1ec81f87d337196d2967bf5f2e03bdc8"
    sha256 cellar: :any,                 sonoma:        "1519a23b9a95ae88fecfdb1137bf892670c01610f8d914d2c2eed568dbec3958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "314067f1b8e8c5802a337742f3d7a6c4faede2dab05d26a383f75ccc50dcd54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3da8337f1f62e69bfdc3cd47436c879c90bfa093b58164996cb1ee9c62ec5b3"
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
