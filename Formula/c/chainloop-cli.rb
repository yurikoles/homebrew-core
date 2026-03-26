class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "26738b6a650fd4d4953451cefbcca05e78a342b7d669e12dc0844bbd59ac01ce"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea174197367e006afd493dff6b4139a67ee6e04dd53d62de1fa2b85bb4cc0d33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed3ae02dca3f05866ef91bbfd693d50241bff61b410faebb89f38738506874f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8221d263f9cfaad63d1aaeaa9c7ceb7751a0f0cd50af07c436e0b36cb4443460"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d6172b475787e7aa4f6b9887c2f735ff7c00f02a7d1dcc3212bf54b3b96e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d061c2cf75a4544981a82f65eb27dcfcf98cfd9858deee0ee3a710ae1a5fc0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09ac0347a03273c925c2f029f1707f3cc954ab9cfcef9895e2e1d771a1e3259"
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
