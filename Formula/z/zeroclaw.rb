class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b792b8391998dcb3253ee4dcabf9732b836725626538e28ec52c75985cc740d1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a563fe2d4abbda06b8714d8dabf4f6897c157fa5117631acbb5d8c2aa9e0cdf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e577ebedffb4eef4230c23173ad9c4b752543c4c47660bdf6254e832a57182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecfd26faac0f112833f3b0d16ae9d315227bb02e18e1361e5f8d9f55403c62f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "46bf937a6ad8c345a1f7e3a35413fa066b3f1cb9aaf704c9ad8a7f0e5db926dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3057f157c32628f3120d2c3536bae14786a22c0507dc6180efbe1e06c47dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1e2bb704103ea6e7b5b3fd41522976c6d71d8785cf62c091634d91eb47ef8b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
