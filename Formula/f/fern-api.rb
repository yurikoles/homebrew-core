class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.94.0.tgz"
  sha256 "b1e8fc504f971b7db244fb347e51f54a5738725bdccdbbde8c60668eb57ea770"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cffad32b6dbcf19d0e8751322cf3f3b3cd9b851ad9689e83c2c5b713f011ab0"
    sha256 cellar: :any,                 arm64_sequoia: "ae5e89bf64c72dbaf8ebc511f22be8e7b86991b32d96d24439994bccf5ecc49d"
    sha256 cellar: :any,                 arm64_sonoma:  "ae5e89bf64c72dbaf8ebc511f22be8e7b86991b32d96d24439994bccf5ecc49d"
    sha256 cellar: :any,                 sonoma:        "86d59233c0321818b57f6dce272af1f05eeabf8fe1cd91f8b292e6e2770ddeb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba443c0ebeaad943d68ab44f817a9d25e1ee55ef15ea5eb9022c379d8de465f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587f86b1f5f629d2e62fe165261ee7a57fff0c036d00c23bb99fe8e7d40eaca3"
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
