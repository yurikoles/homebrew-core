class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "31db246fad0edc33b9028b86052f7161b40821dc759b98c9251cb640b9ad260a"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2341beb7a222fd7796183315f89e4ba66bf543988bbb97a591c218439b28031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1867eff9fea3adf459a0bc11178e41232186af5936d1760224729d9362ac1a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c2861680b437630b4bcb6d2a198a90ef3744e1d1075db024c8e9b2e5bdaa5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "92696bfc136cd0f86b7767d0f0150332e93ae0ddfa9c3c421dc87774950fe9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "530deafc11c2ffd5957f817c1ff03361639cac1b995629f4a2b7a72fdc335174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7478aa1af5463d526a5670f7659aef4a9cb915d536e8761fbbae802d7a36a16b"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
