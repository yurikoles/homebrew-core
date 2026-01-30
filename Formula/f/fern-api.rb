class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.54.0.tgz"
  sha256 "c8e2450f86fbddc9a1ffbd80efaac21a2df53dbddf393ac7c1f76c0746a36d9a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56136b1de9193f94d3288bf6cb00f67916355e74600b006208b6cbb9f60ecf64"
    sha256 cellar: :any,                 arm64_sequoia: "f9f1ef235912f2ef824681c11099c037cd12c84074edc892b6a569d0315b0a95"
    sha256 cellar: :any,                 arm64_sonoma:  "f9f1ef235912f2ef824681c11099c037cd12c84074edc892b6a569d0315b0a95"
    sha256 cellar: :any,                 sonoma:        "0aea4f3dd6f668ea4001a2db2c7a9e314cd902c874629a9914765c5bb9695724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c283184d80c1f2d33644dc70c0d55183c7a2b73e6d1d3dc898918c8494af7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9590bb645b2259b14c9fef60f374dbb7267e658c714c34ff185ec31621cfaf5a"
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
