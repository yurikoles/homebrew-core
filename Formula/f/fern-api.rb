class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.76.0.tgz"
  sha256 "e20e7b784eb396d054c7b23977b4b08158b4f25312f8301fe70ab1ec42280c7d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32fa5cbcec7b74ffdda5545270df28cca5603eaec7193b66ade73e6a13323952"
    sha256 cellar: :any,                 arm64_sequoia: "6dd1b1571c93ab9c291bf1e1fe2fd6402e45891254e0d0459c2070063aac38e9"
    sha256 cellar: :any,                 arm64_sonoma:  "6dd1b1571c93ab9c291bf1e1fe2fd6402e45891254e0d0459c2070063aac38e9"
    sha256 cellar: :any,                 sonoma:        "b1fb256c20b0525af339ccd301b1cb348408b776c05e35ed2a96d6df214ea12c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bb492e6bee49b4e7aacc6db2e0ce72f4dcc3eb9f8590d434d227156e253a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e2067f122416ba94151ae840e90af7b0e3d56b55660fb4f17da102afa0e9e98"
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
