class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "219d0d52022fccbd445ada4b3ebe72d7cf3b6cf20def9714b4d9f59da4453952"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427d7fd06b02413aefc07950d75d38d0ad79b4b99b85b72da91d4004d3a44bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3fec69e2156a5c6c6cf4f1a533b1738d3294727b7b565f18bef38c7dd6114bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f35cd2046865b0de4bf95a7ee882ba47f3f899c5adf8e367fb6dd265be546417"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb1bee8520bce507745ffa9efe0c1a51cb8b6a1fcdb3872b6a265a44c448c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d27d1e75fac96989e6d4076a8a3944430a0a1c4f2b835f803502016b519ef12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6ef408bafdb175f14ce24a7da4380f6bffed8c350491a2c3258845b299c7a4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(5) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
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
