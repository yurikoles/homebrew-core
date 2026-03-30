class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.3.tar.gz"
  sha256 "9a4a7d03f67349b04aa27be41a0b4fb6e4d9e07487505eff3f2ced2959519c66"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e2edd4c801c1d0e100aca08337432db5a2c3c3af30d42212cbae646a0ed242f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e0060a6184141ff6dc7b79b6aade29897968a6c7869ae4a14f9c6989d29481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8ba4ccd83af8f804e36095b8eeba50d8b1f1bb98e3f531060f20ac2348138c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b31126c33a3423ea961db4bf80d30dfb6f6ac3bef893bb78c08ac6015ae8b6c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7967d8a8a007fb78e5f030cb57d234e0d285eaa5cfd3151a209e53d4791b0b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb138d949965153428f4f05a034d09cc131bac746c74c18a942b62a6391e1f3f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
