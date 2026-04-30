class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.2.0.tgz"
  sha256 "66d6f090817ddac296331e20811695c60b1a639d6881f8d96e6635892c454f80"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c4eef84240bc60d3b24746e3969919de1d46ff99d465c06772393039858a4b8"
    sha256 cellar: :any,                 arm64_sequoia: "1ebe80812119027dca321642dbfeb92ee33b53501685c4375c7160553f61aa7c"
    sha256 cellar: :any,                 arm64_sonoma:  "1ebe80812119027dca321642dbfeb92ee33b53501685c4375c7160553f61aa7c"
    sha256 cellar: :any,                 sonoma:        "00e5fb14c6ff8d54fa0aa381e9ad02dccf4777434ca098f61e50aaf8f7594b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f355826429b2bfb43e2dae389f22d81a226763ccf2b0f7496c59097c7ff5466e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e202d7d31051d14d0256526247de818ca026ad5a1071161d0b9ded2c9f6faf9"
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
