class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "1312b4deb0708e0a4e1ae8257402bf4ed67df9c0185d98a5420933d605e586a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "743869221a06a59a77fb752215beec678f8749ec0646e1c076178d60bb06de58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743869221a06a59a77fb752215beec678f8749ec0646e1c076178d60bb06de58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743869221a06a59a77fb752215beec678f8749ec0646e1c076178d60bb06de58"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad9270f6c7ed1fc7a7b051e4fd7d2b13bf241a54a65c5f6ea2bb1c71a4f0512a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8183bdb897f79c9296baa46f83e362d7db461c096495c99ecf1ebd69200b41b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0504c2e55d8705f9e52ad3fe39095d4b84350d5cf2f7ccdf5466273b2b00355b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
