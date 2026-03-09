class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "153a26a64f09a7c3d60858b29ba74e191e3bf6ce433965cf72ab140691234826"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ead8a0cda239faf84417c8a8284e4891381afc5d3ae5db47ff4f054f086eb7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ccd94915755659347bd856b778912571a43ec3d589c7e865766e185e3326d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a37de25452869cf3d20aad7de9199180dcb055343e0177c698513d6973904f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e421f0e68a5c0c6ae4d96f3db544bbd89d582080fb28d86057a49a7ed1cb42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc7d864b5a806fc962231e3411031711cf524595d073709d1182e912177b0a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21085cf0ea66e302d1765d6a18aa7fd90f6de466b0e6c438101a5a898739ebe1"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
