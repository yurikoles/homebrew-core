class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "0bc385c7935b685f6ddd15125e9f0f1d91220ab672374e537e778ef128240214"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e554087d312a788082cb75e8c5cfb866f2d8cd23a3ee3842754f431c5f3c3bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db06fb28b507b4d2c11442a47e3b2664078ad458459f77b298e8dcb814581ccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a583505fe3180ace8a8a5c4161edfbdce8917ab3b0bfc1620bae3afd84dd48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d60f738e04942f5008267896b41ef5920599d8692f2b52836a1ce843b4041a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25c82e7a0709d876ea322abf6d1939031c98e3e90861a76afbaf6fdbaacd1b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "169b4d79498947a279182dc8ca57dff4d5f3f9800873bbd446c28808ab388d3e"
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
