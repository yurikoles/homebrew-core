class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://killswitch.network"
  url "https://github.com/vpn-kill-switch/killswitch/archive/refs/tags/0.8.2.tar.gz"
  sha256 "0a13e6ebe9f05e5cc34959779b7fc078e96246dbc82449c6a8c9ace75ff8b80d"
  license "BSD-3-Clause"
  head "https://github.com/vpn-kill-switch/killswitch.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7a1663a4d840a24e873605173d5b3b268f1e658f348e11fdc65e59da8db1feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0ec09f4b48481274648ca33d56be42d804d1a24d4f607e1d12d9f228496807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4366691141c65359723d291c0d2f0912d3738a90f3bfb650a8f16ad19b60577e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdb2b9555122b312ebc31e7d79d9a5cd5d3afb98d3584d81f80327fc8bb62b29"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/killswitch 2>&1")
    assert_match "No VPN interface found", output
  end
end
