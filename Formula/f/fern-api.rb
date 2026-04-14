class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.68.5.tgz"
  sha256 "90f967b353c5749997ab3b67e1a4485332f278673daf6a64d96b29ff25ac228d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9ca0b62a645d86d3fc4d3638ede974ff9b8860b1ee66d6273c894fff681135a"
    sha256 cellar: :any,                 arm64_sequoia: "d3d5b7d12baf3e585a3351ca6cc83ebe6e0cad468d99aa8bc255c494d3a128a3"
    sha256 cellar: :any,                 arm64_sonoma:  "d3d5b7d12baf3e585a3351ca6cc83ebe6e0cad468d99aa8bc255c494d3a128a3"
    sha256 cellar: :any,                 sonoma:        "98cbb58a6b1bdb22b4579f766d08eb4a77c83c325ca4d7b5ebfe323e0be63665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bcb1fc1839c57688aadb87aa3b7e8722ff19e09fdc15c0109e0f8bfb37a44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "818fde06c42ec1c1286b9f6bf98c1e906956c3f870396a96812368eb73d204bc"
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
