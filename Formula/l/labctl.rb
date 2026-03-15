class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.63.tar.gz"
  sha256 "083a89080a47fc0c8d60bf4f0663e540b19e80f65dda997916401b6d0d30bdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881ccc06d5be55876d8753d84467c1e3b4540a39b9573acf6ea2baad2f81981c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf5415643cc7287b081cb4db15d31e7158b4b78eb4600e51b27163e6640d0863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1024b17e784454cdb9c4ed7a3b2edd180ff4d14a44d76bf3dd8f943b744a9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237ee680225717d5c7adbf9e067e26c229edcaa68f06fd18df83351830e7fe81"
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
