class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.30.tar.gz"
  sha256 "47586b5d8be98052172e1717bfd3b62b7443b6b906a67acdd6ca3ec03621905e"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "c209389d24e324a4cac442c5d4ba638ab83e9c931acb9e6beecbdf73bc64a15f"
    sha256                               arm64_sequoia: "c209389d24e324a4cac442c5d4ba638ab83e9c931acb9e6beecbdf73bc64a15f"
    sha256                               arm64_sonoma:  "c209389d24e324a4cac442c5d4ba638ab83e9c931acb9e6beecbdf73bc64a15f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48fec5f5a18abdece3bda4ddd92bf2ac4490c6f0032de4ec0554c7e55cc8fe7"
    sha256                               arm64_linux:   "5931ea7115391bbb970e3c2894373b8f45de7cc17eb6d266a9f8f62b07678793"
    sha256                               x86_64_linux:  "2950de1e591c4c983b3db7da54147170bc77f68da64a3e00d3864c9321aa1a01"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
