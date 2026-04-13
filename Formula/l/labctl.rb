class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "bef58a3aa371ae74f487637dc356d6a19182e2c13b249bd9f8d8f6b1cad2c395"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3223733c89a767b91d5207fe2a157facbffa83fa7c708d93db80a95e082e75ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa02dea35a347a0b102bddc0df5a80bad307ad7704d680fde5e4f010f2112ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7888210ccc0d45ea420378c21b8addb5401f233a2feaf650b677fb9bf11c42ec"
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
