class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.60.0.tgz"
  sha256 "c11ca1c42604eeac94fa2800c73e64dc48bcd9c2f5037bfd06813c8cec6aa3f7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2864c13241217291c537e9b41061c5af78db9a141699c5542ea86b70f362a45"
    sha256 cellar: :any,                 arm64_sequoia: "3ee8d59ea486168613f352e4b1204e0e623ed7ba3def50a1f827ca03fd23b3c0"
    sha256 cellar: :any,                 arm64_sonoma:  "3ee8d59ea486168613f352e4b1204e0e623ed7ba3def50a1f827ca03fd23b3c0"
    sha256 cellar: :any,                 sonoma:        "50f980bf90151a7cdeddfb54553b83b5f3b20f8aa84e05d10076c62c540c19dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacc5bc073bbb9bb1fb941358d077fe9f809c2bbde14c0079dbf7907c7698220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4662736911c0ca4de97952db4fa2d815453d7687ba749b82c3601840c5fb4b07"
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
