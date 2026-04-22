class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.88.0.tgz"
  sha256 "04c7a85fc704cdc0323264c857f882b1ea6434511de97e15c57aafe060ab4912"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e6e040e8ba876ea6ebe03705f85c05505113cbb662fb4a0f508f5f728098efe"
    sha256 cellar: :any,                 arm64_sequoia: "173ba5cadd4e78f9343a2c439d7826c504cf0efb208a441c76b579617824dab7"
    sha256 cellar: :any,                 arm64_sonoma:  "173ba5cadd4e78f9343a2c439d7826c504cf0efb208a441c76b579617824dab7"
    sha256 cellar: :any,                 sonoma:        "c8a6f7938f79c1628266d4e4689c778f28f3972382641344dd11289b8fde2cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c3900a2e5f11e6a5fe53146770b9dabdc12450a9ed5c59a5f2750c9b5478f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfae3834a06b817e2d24b64fbe5ae244b6490df3fa027c6437803d12c8a665d5"
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
