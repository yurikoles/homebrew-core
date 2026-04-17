class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.77.0.tgz"
  sha256 "b56e9ed347e39eb019e95821619a2d2f6e422c170f1d81e7c3e8e93690a6e779"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ecfa1263a0e1c92447d727957804695394aab519f490d4ea23a2113e2bdf0e3"
    sha256 cellar: :any,                 arm64_sequoia: "3a8cb7e4bcc08b1c9c6c737566ed43e93b534a7ee1b971fc0707b78da3fc3e33"
    sha256 cellar: :any,                 arm64_sonoma:  "3a8cb7e4bcc08b1c9c6c737566ed43e93b534a7ee1b971fc0707b78da3fc3e33"
    sha256 cellar: :any,                 sonoma:        "0145f7059314c768db4c65a83fb944e74fab9f85a4948831f658228ff1fffbd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d94765c0f18285b6dec30f1218b71957fc197c841a19de4ab8b3937d73fb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df84cd6cafcdbbb6d9922d238e2582ab563acc4c243fed33264a69131c60f50"
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
