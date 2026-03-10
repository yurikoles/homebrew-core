class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.81.2.tar.gz"
  sha256 "c5bc4c34f10d37c04309d27eb8facd5bb9f2d64d273cc15a86de7489672135e3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d347bd82fc5cf7af697e25128378ae390203e8ac3a03798dd8780c84324bc2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d36d70ef20d14553344abaec2aa9d69b88981a37359965c41261f14e158bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb862fec9b31ca43bb85d877d1458f78489d8d1ddf7c435dd70216e980dd9a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ed2d624133cdfd8a71ec0c6fcdef2c2933239919e76874c085bb1513163702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b1f5adfa6b9cc40030f270c325d6fd2ee124d0ae6861d09d217f4f27f81793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a09157ebe29cc20f3d0a64ae3833303c3da424c865dccc12e9cc3400326236"
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
