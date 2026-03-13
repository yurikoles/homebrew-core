class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.27.0.tgz"
  sha256 "6ac758e2aeb3602bc8508562206687166e65b1a505b12c11163c032ac900f614"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19b157bcd27bb22172e1fc13fb3d0d64e7cec44153987a6dee423fe148d8c69d"
    sha256 cellar: :any,                 arm64_sequoia: "1e8f8060888e50dcf4a33aca80f46230730406d69b04397fe157bb566d84ea92"
    sha256 cellar: :any,                 arm64_sonoma:  "1e8f8060888e50dcf4a33aca80f46230730406d69b04397fe157bb566d84ea92"
    sha256 cellar: :any,                 sonoma:        "55e53b4494dbf8674d3d391b229ad5c24629e1c1f8afad588a70078800f53e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0203729e2abadeb2e43ca05b63a2052fa3ff4e3f36d5b5abc013a118b9a4f641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74278be7d192f8e836e07b47f42c6b918064f9625164612200e0ac8a09dbde7"
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
