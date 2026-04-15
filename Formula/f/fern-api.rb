class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.71.0.tgz"
  sha256 "93586a743b48d0006c8ecb38f1dfa0104943a4d9a5873936742709da43de6881"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ed7b05025b6b1108c4e9c2f9a751cf957ef4c08798ec1fc46e3ed9830a9c379"
    sha256 cellar: :any,                 arm64_sequoia: "31a4bcb6745d8a3e289aaed94cb84177efc5f4cdbd0a432d3c7bea5046e36a21"
    sha256 cellar: :any,                 arm64_sonoma:  "31a4bcb6745d8a3e289aaed94cb84177efc5f4cdbd0a432d3c7bea5046e36a21"
    sha256 cellar: :any,                 sonoma:        "ecd63d248028b651a6ca36d4bd97886f611c5e97b64266cd5896e1230126975b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18d38584b045b39af2dbfc629ae86db6e88f4217976e9177ab9c3687aa85ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f712e41a22f90a15f2bfb3fc6b076ccf8351b5a11838f09a64864dc9585141a"
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
