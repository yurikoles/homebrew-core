class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.34.0.tgz"
  sha256 "1c85bfe44bef2dae71ea3051d7e66a9da139634ff98d607d48b6be29bde43c6f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5634e8010488244e20bf35e306debc2c66df670189e4cd779d630b2459287210"
    sha256 cellar: :any,                 arm64_sequoia: "7500d4cb905b12d19564e928b7e35c5b74dec7d40d98a1fa23f04eb4cf075891"
    sha256 cellar: :any,                 arm64_sonoma:  "7500d4cb905b12d19564e928b7e35c5b74dec7d40d98a1fa23f04eb4cf075891"
    sha256 cellar: :any,                 sonoma:        "29df0eb177d83f6ac6c682f93f73fa0e19bc0b4f6a46bfcdcad6c17ccc4c69dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e8c2feda97481d256d666db18a7a2472f9e51973d38dc094760571cd35c3adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0ab2aeffca456c0fda265cd42b9e136f6b63fbe0485b4401e9cd94699c6ffa"
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
