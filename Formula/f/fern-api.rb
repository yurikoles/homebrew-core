class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.81.0.tgz"
  sha256 "7d59b22b6254ebfee2d1ecbcde101a01123f2968f9e644b61329032a3f6d47f9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "322639857f33e177756bd4274d89ea339d7c1e526669cc5982f47efdb19366e9"
    sha256 cellar: :any,                 arm64_sequoia: "37a2174f5487675a4cd2752d8378caf0e882cd242abdaaffd5e4cd2fa696fc30"
    sha256 cellar: :any,                 arm64_sonoma:  "37a2174f5487675a4cd2752d8378caf0e882cd242abdaaffd5e4cd2fa696fc30"
    sha256 cellar: :any,                 sonoma:        "9eb754491822dbfeeb3eefe735e6c3dc7593c1d937b1a41fc1548cdc0f577671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085b7bcc03905998d630f620538d75999570cad67dc25fb42c38dde1d3542114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5ab76b5a20f55803e8d5988c23cf4d5693d9fb110f19e88162eae3a2a319b7"
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
