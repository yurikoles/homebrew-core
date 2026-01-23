class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.49.5.tgz"
  sha256 "5b4764314ba700e0d6ff707b43f70dd4c93dd684e0046906cc000ab4671cd0fc"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3995b8172c9260d90467e27ec603fbec560bd0bdea828e0c1be32e1bedbf4938"
    sha256 cellar: :any,                 arm64_sequoia: "0ba1ca65f19fc8b59aa3704b0def0c6f551ee29160b9942a330ff3c6e6db5fec"
    sha256 cellar: :any,                 arm64_sonoma:  "0ba1ca65f19fc8b59aa3704b0def0c6f551ee29160b9942a330ff3c6e6db5fec"
    sha256 cellar: :any,                 sonoma:        "800c57424a914f4ab08e551a402c87482b1139f1bd038bba03ce29d03181e4cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480df0150c6894d8b125e035094567347f36d6fa605a97833878f533ffccc593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a9a7a09d6de9f55c302d2182a110ffd8f2e9511b74f92e93aecb3326fb9e40"
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
