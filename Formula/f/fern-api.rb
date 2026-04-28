class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.105.0.tgz"
  sha256 "95f43d39632dd55b15bdc916399e5cce382ebabf7d1b5d2badbc3efc8bd0352b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fde36d64e11b6f9d8707221e11eb21b3fe5c50b053ed8c28f2f61381ce71306e"
    sha256 cellar: :any,                 arm64_sequoia: "e84c397fae8d0e70c84af627cecfc22e0f9b6219487abc5c0a0ad1fca7fe3ec7"
    sha256 cellar: :any,                 arm64_sonoma:  "e84c397fae8d0e70c84af627cecfc22e0f9b6219487abc5c0a0ad1fca7fe3ec7"
    sha256 cellar: :any,                 sonoma:        "5abe78b8609208fb42c9f6f32468b619c2576724f96c4fee8b0751cc35aceb28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6e7cc8afdcf260141fc445f74e8ac4a8af72593766bd08a8c56eb8d7f5a1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394f38e74d30ba65fa31526939340396b6e6d5d275aedbd42b80e5dba6c6f2b3"
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
