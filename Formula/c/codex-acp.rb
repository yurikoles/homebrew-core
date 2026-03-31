class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "21b7ffed68e817df638c8e939c376e0ccd2f6f91b420730b71d3ba418c3b1205"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "688529372f4c2401a2bd76886feaeab24ee38257674c6cd71a4a02f0d1dac210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39f570b88118a73fc60daea931beac138a2098ba60a807fbe25c42222678217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a172190af0a4f02afdfb6a0de07e80b1bba55d2016734573058dc409b9ca22b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ea5581471d7f87f5015585711c8355d978a9d551e28f3a3eeddf1a789e40664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5351e1051f952931a5cbb26e9067a6ee8b2e0ecd9f135fb089349b14418fdf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc706bfd432ba944911a1e066211359538cddc42dd6ad31949a0b6326708723"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

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

      line = Timeout.timeout(15) { stdout.gets }
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
