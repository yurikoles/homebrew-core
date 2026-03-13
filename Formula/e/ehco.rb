class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "002d18a6b631f5026b2dc90dbbe55dc46469fbaaef24ad812a281356d54ebe26"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b8caa88f618075e34f5038eafe1aaaa09b68f0d2dc3a08ee1d9d2edafbbad14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67b21d26063cf53576be6b3e1966b1cf63bacc1209163a257fa2f5cd214d668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3f0180c2efd1366eda80945efe3246156a52b3a8b889816880dbc0cd820d85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4346f2aa4c0db369932c13d0c1ca3988b0f2a28509b536febf2bc8bdd51509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c9a614d07b9a81f89941601b9ab8f4c978414b83c0ecef938d2e0c510cdea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e9e6ba85a46f6cc8f3bf833db44298bb489bd895091ef13c843f5f17d95d1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{tap.user}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]
    # -tags added here are via upstream's Makefile/CI builds
    tags = "nofibrechannel,nomountstats"

    system "go", "build", *std_go_args(ldflags:, tags:), "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run tcp server
    server_port = free_port
    server = TCPServer.new(server_port)
    server_pid = fork do
      session = server.accept
      session.puts "Hello world!"
      session.close
    end
    sleep 1

    # run ehco server
    listen_port = free_port
    ehco_pid = spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{server_port}"
    sleep 1

    TCPSocket.open("localhost", listen_port) do |sock|
      assert_match "Hello world!", sock.gets
    end
  ensure
    Process.kill "TERM", ehco_pid if ehco_pid
    Process.kill "TERM", server_pid if server_pid
  end
end
