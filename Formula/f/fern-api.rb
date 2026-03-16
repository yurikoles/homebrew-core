class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.31.0.tgz"
  sha256 "77257cc618c361e379ce516e40cba10661d60f65df2b21fbf7d0d51526d90d35"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd99599739db223c918406e1504971abefe7a6eba0b7cb27434666c9a0f702c4"
    sha256 cellar: :any,                 arm64_sequoia: "d7b8c9568a2c17db0fff921414fec9cdab670b409a73c4dfbf5e36228b1c7c19"
    sha256 cellar: :any,                 arm64_sonoma:  "d7b8c9568a2c17db0fff921414fec9cdab670b409a73c4dfbf5e36228b1c7c19"
    sha256 cellar: :any,                 sonoma:        "ce30e07fe956512a5a936cea09543e99a081d40cf9b11114f104dec621f85d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "261b7b6676bb6d7709585146944995eb1ff3a62d9e09898b91a4ba2e1b7b0cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24191d6f972b91c3c7972feceea3363dc463e9141f9d4d3192d8ab95e7f74143"
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
