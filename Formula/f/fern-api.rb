class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.41.0.tgz"
  sha256 "3eb9694ef90200a48d036d126daa42c55e1bf1c1d5bcbbf410682ee62ffacab2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b94d5ac8420334a019f268b98a4f73966af29fb5742857dbf6f4587040348f1"
    sha256 cellar: :any,                 arm64_sequoia: "cafee7b7ef2a02a9061670ea949d70bb601f4a386277c61f582750996421961f"
    sha256 cellar: :any,                 arm64_sonoma:  "cafee7b7ef2a02a9061670ea949d70bb601f4a386277c61f582750996421961f"
    sha256 cellar: :any,                 sonoma:        "ed869ee0ee1795720e11527b349eea083205778cb72db5b88a7ddca6d3618c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec23a91919889e9926bfb0f411e45fc545d58d4a5cd64c66158b147a3d89056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f39a7cfee9fd406346598dc2deb81b07359c88cb31fc90c5db34573ab43818"
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
