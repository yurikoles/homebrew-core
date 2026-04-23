class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.73.tar.gz"
  sha256 "508d6f28becc4891d38bfca596e3b1b6a69b8b3e37dba5aea5b81d57a62a21a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54c731c74a94e58c50aaea9394402cfc4f2e274953f2f21bfe4b7d0a680d1ec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c731c74a94e58c50aaea9394402cfc4f2e274953f2f21bfe4b7d0a680d1ec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c731c74a94e58c50aaea9394402cfc4f2e274953f2f21bfe4b7d0a680d1ec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8908ee195f9a5054bb7f58e21597faf9c8e3723c5fcf6f3a26ad00f3ac4494d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f664e4abbf8af53230cbd3a8a3e44a1326bd6f136f7790a8c92bbd31a19e1583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe4debcc2f45681d20483eb92e3a9cc43ff6568d433030b8891cc36fdc3b703"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
