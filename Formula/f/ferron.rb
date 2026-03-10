class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.6.0.tar.gz"
  sha256 "50e874e4cefa8ac3601b171ffd694c13bef87306ef341b00973de180a3b1355b"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78ad2dcfd18eb4bb4a6e43b167602800c469d4a4e98543594500c363a7417ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c975191d2bf51dbc1a3e47763ec80b831f53cb256be4eb7de78b3bcb5ffffdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07bf9c625cd11d0297d4102fcab9d5e3d603bd3573582f966475c1b31d0dbda"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5550b14ce9ed6b6e99c17b76a4e2f56c716f942e8e59189826339644a0c9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0916ae5fbb6fea267ab42ab47d5ec3fc4634895018f184e9cc08252bccccb5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0bd422a75596f1cbf1a1496cbe9fb1c10ef8686ac9d1b4021ac71e5ef8e2d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match "The requested resource wasn't found", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
