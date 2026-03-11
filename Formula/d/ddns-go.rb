class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.1.tar.gz"
  sha256 "e43819a9c3bce096f17a110af741da7fc2fdda1ecba7e043f31b2521a8758c5a"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77666e9b5984972bebc0852fbcc82c707bc077d24ee430dfb6d0adf31d881d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77666e9b5984972bebc0852fbcc82c707bc077d24ee430dfb6d0adf31d881d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77666e9b5984972bebc0852fbcc82c707bc077d24ee430dfb6d0adf31d881d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "55cddd97ddcd8a423895dcdeb05343209aa536992f595ece827f5aea598ef46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92b9a79c820bcb5ccc2f918407e7fd66426f43ef12ad86fcda255d2b220e2406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7825ba5af48b39c479c2f4244249819b52874d88d421dfc237f700fa68b66f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end
