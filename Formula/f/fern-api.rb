class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.88.0.tgz"
  sha256 "04c7a85fc704cdc0323264c857f882b1ea6434511de97e15c57aafe060ab4912"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f1ff1d9eecbfd54d96634b6900580afb89a48d579fa1c1b724f7780b7d3442b"
    sha256 cellar: :any,                 arm64_sequoia: "63e39fb959027067c9a22a697f19121b671043d35ccfbfa059bea17b335987ff"
    sha256 cellar: :any,                 arm64_sonoma:  "63e39fb959027067c9a22a697f19121b671043d35ccfbfa059bea17b335987ff"
    sha256 cellar: :any,                 sonoma:        "668c53be038df05ca2f60c05e5bee22678c2178b327de4b6747bce2149da6a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eef0b9ff5c48da0bfcd2ffd9a1941ee3e3825075c5f58e65c2f3d24c7a79f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "becead1a7c2a44459e980778563b2683d7b9d00db299a90eb16ac1eba4a4a0c4"
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
