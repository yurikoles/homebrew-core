class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.71.tar.gz"
  sha256 "6d9bcf312d94d8b71032bdce976eccd68eda0fdc929bffab481825728543d409"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50698db3914f4fa88f43d194043dcfbe1318ac30e7af97b0577ac3ba2e5c1bcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50698db3914f4fa88f43d194043dcfbe1318ac30e7af97b0577ac3ba2e5c1bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50698db3914f4fa88f43d194043dcfbe1318ac30e7af97b0577ac3ba2e5c1bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4394d1972189233bbd1aee204a88c81c1e2cd5ed901082d6fc9bacbb0fb3098e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3160c31cfcdebb167d5d26c9a798aad3a0c405a23b8d3ce7316f6cf59959195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ffe98be01a5397f0278d2f4cd2ef541271eb1ea50e93cfe66a70cd317425db0"
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
