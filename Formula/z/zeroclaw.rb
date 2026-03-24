class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "82613d0201cb6ee3169e3a35fabbfde82cd574cc26a5ab9f16325cb335923202"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5901e976cefb9dc19b5b3b6d181a4fca1903ec10bb19dc731009ebe01eb262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25fad5b87cff8a04c1f6b04591c7874b62059795252819099f777eb706ada055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23bf1ca89aef93d67033a08cb6e0fde2974ba6c2addf6330336939f9be165de"
    sha256 cellar: :any_skip_relocation, sonoma:        "c37353bbe75d9dd7705be560839cb3ee146c943d392380efbe31baa64357dfad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "193fab59683af9d420ae37ef5fdc9b4001129747b8003157d14ff4629c144b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2b7e28d43387560f02235102b8dd618f43f4e542f59e0253267c6cf4971490"
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
