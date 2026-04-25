class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.96.0.tgz"
  sha256 "050c01875ce0f6297a1b075438572a56ce10ddf87bc5bba73646c761d751620f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09083b187893dc7c41e9d5bfbb57f1a25d0adc1e2d457d60e82885c16c8ab998"
    sha256 cellar: :any,                 arm64_sequoia: "d2e193cc93d05acd82c8c7b69313dc668fcb5cbe865c44c661bf1c42e9ce5474"
    sha256 cellar: :any,                 arm64_sonoma:  "d2e193cc93d05acd82c8c7b69313dc668fcb5cbe865c44c661bf1c42e9ce5474"
    sha256 cellar: :any,                 sonoma:        "efaf4a3e097b1ec68033de63341b6e62705c317f66d61197c54ac317ef59d521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc4e0f1979c9551c76cccc4248f0785211018efb63adc25f650a099b0403d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394566732cc03f489137e09009ac2c2bcd9ab02d252cab1541f2523d42f8fcf5"
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
