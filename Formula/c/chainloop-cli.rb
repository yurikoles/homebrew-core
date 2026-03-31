class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.6.tar.gz"
  sha256 "9b81222b0c0b975164445d0dc70a571cb3e9e1918e4e6db6a0538fcd59434e7b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1740be76b7fa402c1a81f2c13318c0e05c4b64aef068118edc24289b8524f8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4207f542afeccc321d7d13352855229003cc21ca0a412de943d1f32d4257a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885d79f3bca5f466a2df41cb7a7c2552d2f89821c06efdedd49281b60a2c593b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e721c7c5e82e6d041ee09a385902e0461288276fb5bee7d76ab31769b70836e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4f9a1f743c2622a4086c119ae166995e3274158daf064f30f86313a3ee8fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61637ed20665d9c1166159eef1af304107f42c0fac1b5e1b80c382cd7350d22e"
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
