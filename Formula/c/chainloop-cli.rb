class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.93.1.tar.gz"
  sha256 "b536fa80a7f52b4bfd5a1d88d7c01b49c0dae15685999803b6becaba29ab6853"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31dbceb6ed3d1ef6630e9c9ff92ca6a3b3d969009905b034b8be69e9222bd947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9488c5410f2c4d0994584c8bcd5776dc04a2d5def7f25a0225b2fd48e8c424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3df9357a15de63ff734dda6532bb8fb13b2151b0ee63c33dfd7c079b2bd990"
    sha256 cellar: :any_skip_relocation, sonoma:        "a615bcbf2a80c502956ef8d38e36d0bd24f4e11556ca6530d2c60e3239079d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a5813f21dfc0eb40e031659e5d6301aba83cbb30931d2d1b53347d350dc7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5998cc99e9ab18e9cb4bf8a08abfb2ff681ef72995f467f332af587f92d1b19b"
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
    assert_match "chainloop auth login", output
  end
end
