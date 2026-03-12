class Tsshd < Formula
  desc "UDP SSH server for trzsz-ssh (tssh) with roaming support"
  homepage "https://github.com/trzsz/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "a303c14bd5a41303d56254cfa97b93ca5025c0138a8ceb9d0d777eb715b0c1bd"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tsshd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsshd -v")

    assert_match "KCP", shell_output("#{bin}/tsshd --kcp")
    assert_match "TCP", shell_output("#{bin}/tsshd --tcp")
    assert_match "QUIC", shell_output("#{bin}/tsshd --mtu 1200")
  end
end
