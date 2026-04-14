class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.6.tar.gz"
  sha256 "60505ad420882c5f64b45d449e8cd9f37e5cc4189558609b0f14aeca71ab0bda"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bcd7794cd91c4be99ef07940e0d66b5536f4dbe4554e029484f1d9d7aaff74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bcd7794cd91c4be99ef07940e0d66b5536f4dbe4554e029484f1d9d7aaff74e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bcd7794cd91c4be99ef07940e0d66b5536f4dbe4554e029484f1d9d7aaff74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ed510468b944526b655c9441cef74ce8cd489c55aa3ba04f69a090bb6e8de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc46734bb34bc1f491bfa0c506735fcd4b1716e017d913bcab862615b696e560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae710f1af4bc7aa9a4c051f9b8135c73ae567384aa9148b34ed97bffd885f77"
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
