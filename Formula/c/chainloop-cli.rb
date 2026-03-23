class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "2db0c8f2cc121e97c1c2305ce12ec27554ad618b37422ea61241a69bbfac9380"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281fd8077d2a5469c7d88dece14bf76df73a18dac6ad8cc90530bbefbdb70964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ebf61187f2046c844c113b1651fce124092b279d5485817c511f1745b22f140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1655826f82d762e2022e89b1268de5492a0a9d19545ced94a381619f5a92d8aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1eea0b380c8a220afbba9743112eb986b8ebd3b37a17da597b22b9bab38ad23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30c4225e7557d46dcc754f5780ca3c539fc468f31541b9d61b1f373dcb674c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764c4318615a31c32924a23cf1e1b07b29d2a9b2987a27378de52673bd536cef"
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
