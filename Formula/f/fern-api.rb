class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.29.0.tgz"
  sha256 "1f9f09efd79cb4d66f68bed56a7e3fd4847f99c47e5cd33d917b398f8637b427"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a66af8893d16638aba5e400b47c1c8c69a1d703e11eb1c40fe860a602892dcec"
    sha256 cellar: :any,                 arm64_sequoia: "16e52868fcb14a50880cda6da80aec4b64f8e894971a559227b5083404a37551"
    sha256 cellar: :any,                 arm64_sonoma:  "16e52868fcb14a50880cda6da80aec4b64f8e894971a559227b5083404a37551"
    sha256 cellar: :any,                 sonoma:        "39e937838361b8c072a4c047f47e56f0be49ab9a12289d456f97086e8b1542ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c521deb493b0bbcdf962b9487ffdd25c8f135d7341d2feea20a8567231e92b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c0d6b53343b4fa915bdc3d0e5a7aa33e88470a6f781e2d298867524e3b8979"
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
