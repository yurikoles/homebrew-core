class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d95d7a7fd41e1cfd23ae506d09312ffa9e67f121668cb9a11580bbf7b5e2ab60"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68ea53ed19bc6656b1f18a3d0a051a867f59d6986afbe22753b240cff4046b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c510b14c42ec53eaf20cef003626b1e84e2380e7ae564c7e578c12666c25e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967c69d34a0e30c6f9cdc981d2878305c2387c285cdd78f7b93634437bac3c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "93b79ab03d8a662ccde03bab6e2fd697b8f7c8effe8b4aa66eb31fcade968858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a3651ad59cc7801c3fc7834630b8059174154512f5a991d88a3f0d28b17df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ae641ed7a7782f62410d8fdb951da21ce9efe9c7e073cd06b4794c5a8567e2"
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
