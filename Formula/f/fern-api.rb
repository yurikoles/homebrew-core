class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.64.0.tgz"
  sha256 "0cba40236f42386d64c87ca4a9d0c84343de3662278a79282a7e8b684cade5a3"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e0768403b07750d87d813d10b1925cd8ae3db0d8235a4053fbdd5e9caddfeef"
    sha256 cellar: :any,                 arm64_sequoia: "0507f35053e102810cd6adce01701526677461bcb251dc7f59f846f29c3242b3"
    sha256 cellar: :any,                 arm64_sonoma:  "0507f35053e102810cd6adce01701526677461bcb251dc7f59f846f29c3242b3"
    sha256 cellar: :any,                 sonoma:        "b1f01d26864d95943ff5cc9b736f26fde4beec20244dace120b9152285fd2d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49a267603393f30c641b24c21afdc06341290d00bfedf708300283400e7b9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f388c6357a3ea0377883b7b4a618ad9079147056a9765fdb541e5515c8bfe75f"
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
