class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.47.3.tgz"
  sha256 "4da9b73676b6f05463bd383e74875ba04a759117f7b664bd084e89db36f3cbd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5596604929295f785b5a089a0bca3af89c10db11be022e1547f6797225ba804f"
    sha256 cellar: :any,                 arm64_sequoia: "9240961e1ea264dce1f3d52b92b19600f8c167e96a8c7765b5904eed09a97014"
    sha256 cellar: :any,                 arm64_sonoma:  "9240961e1ea264dce1f3d52b92b19600f8c167e96a8c7765b5904eed09a97014"
    sha256 cellar: :any,                 sonoma:        "e02ab4445add751bcf70295684c7a7423cd539708e4670218ecb5a9fbaaafac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab333b469ede1c6c871e5db8df2aa1f972f4fde42ae504c1570a69bdea1b507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1629ef6a1d5e37af445260ab3b5de2c6a70bba5eeb82a378cb87072821667cc4"
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
