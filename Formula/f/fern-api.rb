class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.93.0.tgz"
  sha256 "655c438cec48b11d4109eac5de807db4e96d9adaa88ef98b72b17af1d86ae495"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67a4cae5011e5c5f6aa0a35d1cbc5e803a49a88a10e9ccadf386ade3d866ceee"
    sha256 cellar: :any,                 arm64_sequoia: "0002286d52c9499aa3181621637b0ac70220c2a2c49164916cdde43592185d4a"
    sha256 cellar: :any,                 arm64_sonoma:  "0002286d52c9499aa3181621637b0ac70220c2a2c49164916cdde43592185d4a"
    sha256 cellar: :any,                 sonoma:        "fed4bf91b48da97e9aa538b06b78560a36b915102606edc33eb73505800a0814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aaeba1d7116941dc064f5fe7afcb5ae472c0b1f3580a2360db5264ef923cf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7945a6763ebc924a9c1fe80f8be1f73ed7a1a584095961508dfdac89618b5f"
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
