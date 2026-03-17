class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.22.0.tgz"
  sha256 "61cfe47d72e50586c7965d4963ebeced476f6d924fa84813823493683cef202e"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "632cc4dcdd8b0576f958864146b2a68e721ec42c82d82976d9a9708d602a03ff"
    sha256 cellar: :any,                 arm64_sequoia: "50fb102f99d8a2e2968ae2c8908b970866800d951e5e7ec7a01c25b86abeae13"
    sha256 cellar: :any,                 arm64_sonoma:  "50fb102f99d8a2e2968ae2c8908b970866800d951e5e7ec7a01c25b86abeae13"
    sha256 cellar: :any,                 sonoma:        "38d3d03d7c1bb9270bef72865b84be4dbf1ea5717c528f58375253f1a5a5353f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f23bc48d3002e939aa00660ab95992ec03db09da9b8accb2395b87dfa68f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f27af1f6ece880a4ad2a0a762e2292422f8420a36210c2cb12afc34565be87c"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                 "node_modules/@anthropic-ai/claude-agent-sdk/vendor"

    %w[ripgrep audio-capture tree-sitter-bash].each do |dep|
      dep_dir = vendor_dir/dep
      rm_r dep_dir
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    ripgrep_vendor_dir = vendor_dir/"ripgrep"
    platform_dir = ripgrep_vendor_dir/ripgrep_platform
    platform_dir.mkpath
    ln_s Formula["ripgrep"].opt_bin/"rg", platform_dir/"rg"
    bin.install_symlink libexec/"bin/claude-agent-acp"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thr|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
    ensure
      stdin.close unless stdin.closed?
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
