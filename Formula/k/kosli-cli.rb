class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "8dd436afd5f830c6a8923c208301d3dd2c8a3385516aa4be7f6e7ac4b8a5b80a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c4b432bde364bb46192490b8cdf57d3f3742feceaf391b0dda85466eae33063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4dfaa7963bd90c676a85a9f4ccce348857db55a3a5a27eb29c708482252a7de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4dfaef44e4d26e6ffc7c9f137a6bdce89bca856639a65c86df877cfd263789"
    sha256 cellar: :any_skip_relocation, sonoma:        "6faf943840b506bc665f2be308ac1863a0adc0136f851a77a406a9f825d11ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90f057cefe6942d1b2bec80e5e778d52286d4d8b1c8f932f08c3da26ac0b742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35057c2c67f9455ade2a41a55c66c4366bc7ad8a1c55620dd366d29d95fbfb5b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
