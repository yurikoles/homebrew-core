class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.49.5.tgz"
  sha256 "5b4764314ba700e0d6ff707b43f70dd4c93dd684e0046906cc000ab4671cd0fc"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d356807240bdc5b06405a3f66156b41fa433556995b9e015cbd1d075e5200947"
    sha256 cellar: :any,                 arm64_sequoia: "1b394fb1e479d6f6e19b1300d1b38c3f502b97dd0ff07272aa83ba200f852c74"
    sha256 cellar: :any,                 arm64_sonoma:  "1b394fb1e479d6f6e19b1300d1b38c3f502b97dd0ff07272aa83ba200f852c74"
    sha256 cellar: :any,                 sonoma:        "ac537d6ca963de983c426537ee8191a07ab38be1fb2b02eab66a430974ce6e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7485e4551f2dd904b2d19af12ee5fa01f50a7bcc69b7da82873d139b929dbd42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57575ebd6803747a134c795a2b246a9cbc5186d53416935d2dafb2feadb2927"
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
