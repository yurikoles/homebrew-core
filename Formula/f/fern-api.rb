class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.22.0.tgz"
  sha256 "b60c49ad5ddf7ee13a4687250ea078f24dfcb302c5b56c8ac48fc693d9f85557"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "540229e70047512de6a04abdacd0a2736e2c0e8abab1832a26926cad21c3679a"
    sha256 cellar: :any,                 arm64_sequoia: "c2f30ca373f9373d1e7a9b1064540e02b68fb1af8361d52b44f748a9dcd57a56"
    sha256 cellar: :any,                 arm64_sonoma:  "c2f30ca373f9373d1e7a9b1064540e02b68fb1af8361d52b44f748a9dcd57a56"
    sha256 cellar: :any,                 sonoma:        "eedf319c63b5972921358743bdbf83580cad7ca1769e3acc748f9c69402861d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4820ded24c6f81a90935be69b518be3757b22d58297254617405e661b0d3be26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dcb51ae7ae3be183f56f2f25305d8cfbb2a0ffe8b215b508381fc72b8ef2982"
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
