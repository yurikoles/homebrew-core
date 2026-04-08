class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.11.tar.gz"
  sha256 "8bbe442da5f3faa2df50a98354ac897c2b5a1017ca6d2a7ad4a42d16e377beb5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "664a23f9fcefdad478d0aa23413b6271756352b3a704c68cb7f5e2c074209541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a3cb139b0edf8aef00008b1ab70516968e72ff7ebdac7d6e4bbe87bebc7302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2948a7cf6553ea5b849dfd963451926c1041e65efbbbeca94e9214cdc5b52f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73689e7abf12478504a958844410dda4ac3d26671aee42861546d0ea3112ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68210c30d104e391b6e449509f85b3cc62a0325ab5d059f58a91e96276e8a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc39285a3fc109d7761751bf968afaf8c8bfdbd48f1c342a717761f97c1ce612"
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
