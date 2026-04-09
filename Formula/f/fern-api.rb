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
    sha256 cellar: :any,                 arm64_tahoe:   "f9e1de787a7aee7c4ec1af075ab109c61468bfeb8a6d53e3a88702e3bb8a694c"
    sha256 cellar: :any,                 arm64_sequoia: "bf3f917797af1f38b0dbecd383fd2847955f0732a82c0dfa7e38917663fe1db4"
    sha256 cellar: :any,                 arm64_sonoma:  "bf3f917797af1f38b0dbecd383fd2847955f0732a82c0dfa7e38917663fe1db4"
    sha256 cellar: :any,                 sonoma:        "9614de8aa045bdcf76e366568bcca6e14e0808fcb327366ff4e8e0072ea7f22b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19059ec9087885fedbab881f24de84cece44a13dabbcb383845bd69f74f74cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721c31f112166716b6c50446d580ed0ac107f526e42b0716018ff726d7c9694e"
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
