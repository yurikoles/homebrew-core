class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.74.0.tgz"
  sha256 "330a051348812972a6404e7fc9f8289c9f2d5fc4467a60a84a945adbd1674bb1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "433c813c257fa30493865eb07b8f4f02ae00019490cd70520f9510cd16b42f67"
    sha256 cellar: :any,                 arm64_sequoia: "a6d36c33b68d1010ce9ab561a18a69fa46a69987142e8f57441ee7c0dd8b1ab5"
    sha256 cellar: :any,                 arm64_sonoma:  "a6d36c33b68d1010ce9ab561a18a69fa46a69987142e8f57441ee7c0dd8b1ab5"
    sha256 cellar: :any,                 sonoma:        "04cf07b8232e6234b2041688fb9d2d29c5a6761079e51dcada1abfef78715051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410269fd49142ae51820bc7040d64cdcc3f4c8f6b2a0510a650733e1537f4213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f0d596adb0a6f7bd0f4c458068fd21f6d699e36686b32aa441eca16ab577ec"
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
