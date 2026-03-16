class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8f85397846f24dc945edf5d35e9e5f558e1f92d56bdaed8bc4938e60048a3659"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a26b1b76feb639758e1d60716c15ad036f1a528c88d02429ab705f9f2f4ba2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9474bcfd6b06ddba5ea53a1b1d0702378e499503b9d83d8ed9433f3b81071ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6993e9adad559a98c913c687f1b3edf9008065568b30f81796d79ef3b4e9c896"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b14587f9e64f253db7114a2026e1a98116fcde0c67efe90c7c7c82306ec14c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330ef43998d56cf5f650229f3b6fa6e91042d2c7a1d3ea9fce6d9f6d90317602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf52c44b7c5215fa8241315ac7f5a91150ee243d935816ca338f8b43cc1cdc7"
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
