class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "3fcf05ffe220d9bb2af7706d0e3e6b3b24594861a5a249cce2ea6cb90dbdbf8c"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bc6c1dbd2b27244d821e3c0e31e664048b3dbb1b66cafdb671ed1624dea9874"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26cb048eab01ce0ca623e46b5f90939889c68a827d6597b17262ace1d666274f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c99f4b698a8ec0abb821a8f73633b7679a99a639115ed402be169c71995a886"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2abb0080f83872c080a7f3e82ebcde87ab52c371b2d038c1e6aed27faf94b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48aef7fdfe992f9415cf656d94378b8cd1a1ef3c655386c541e4cf2559ec75b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8965532453c9c64a72950397bebe839bb77bcea6f76c06db7ab310b478c7fe3"
  end

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
