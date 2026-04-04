class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.3.tar.gz"
  sha256 "ccf29cd55f0460a17ee6de2017f5770224f546b8510ec968f6ac304bc344a371"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a09a1f5a5442583c67396f1c986e1583433bd43c89c090071322b4f2d82a065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a09a1f5a5442583c67396f1c986e1583433bd43c89c090071322b4f2d82a065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a09a1f5a5442583c67396f1c986e1583433bd43c89c090071322b4f2d82a065"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d960d4a69d7cd06b4d0dde782fab3859576858b021ac3266cfaae6f1c2dfedd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39bedd86b1cdbba4dcb18a748f73eb9725bc987ca274886b1afefabfc7ec5275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa0f857be0f9eac7b9eeb57f2c350decb8662aed4b762debeff0d31776f22ef"
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
