class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "6f4853c3c1acd9031f0da9b5c4d3a2ece3142f48ec4e4a32b15240f43c56fd74"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af7ea44528bc31d59f585bdbbfff8ff03a86b7e5f9fc7ea060ada21c656f1681"
    sha256 cellar: :any,                 arm64_sequoia: "5f4f7b0d7dc75f3ade3b2294740db7df46ae7410abb5f6d35004044e2bc00c6c"
    sha256 cellar: :any,                 arm64_sonoma:  "3acd09e86deab5a9f8e2453df789c50c8373e67cb04a30822f34f0a62fefd6f8"
    sha256 cellar: :any,                 sonoma:        "5f487dbb687f05d411fb2ce704f17b58b59ada130d5c4ea3ea8284aa4d9a49dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3cafbf7fa6a0e91ee79cdaaae933d51e0d2ff729635a55e97c1fe6f2c4daae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a6e0efd743d041e1e1621a0ee454f92ee80b1476531db1ed685f7ea392f039"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
