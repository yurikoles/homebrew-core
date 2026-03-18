class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.36.0.tgz"
  sha256 "29a40c881c7f4ba36e5d2503f2ac81c0a08f05b0d666f408bd3e34425c1d7720"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a3d53f0bd62877e3dac100a74aa5cfb63639cc6d4907b3e84d06b0955bf1bdd"
    sha256 cellar: :any,                 arm64_sequoia: "c476269d6ab09b76628081b863974a0e4a3fbc63f65053b475df522de87c1f6c"
    sha256 cellar: :any,                 arm64_sonoma:  "c476269d6ab09b76628081b863974a0e4a3fbc63f65053b475df522de87c1f6c"
    sha256 cellar: :any,                 sonoma:        "deff4a6a3f1cadb322c9a12c8b5e805415a6ea88a2439a7650faae0a26469bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ff5128e9a8743553e130d806cab7844a480a71f8a052665d825ab191f3217c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b31db8250c0eb5865324cc3732b31ec3ed0e488f15fb57e935e0e8965059ee1"
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
