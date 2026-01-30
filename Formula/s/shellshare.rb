class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "3fcf05ffe220d9bb2af7706d0e3e6b3b24594861a5a249cce2ea6cb90dbdbf8c"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port

    Open3.popen3(bin/"shellshare", "--server", "http://localhost:#{port}") do |_, stdout, _, w|
      assert_match("Sharing terminal", stdout.readline)
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
