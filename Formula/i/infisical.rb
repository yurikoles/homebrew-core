class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.64.tar.gz"
  sha256 "196d96a771028f4f7ea7b4031b6efb44aec942a2b96e345765c478e1cf565726"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e74e7271a42b741eecfd747fd1feef4976db19225f6e5afa945579ea7ad427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e74e7271a42b741eecfd747fd1feef4976db19225f6e5afa945579ea7ad427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25e74e7271a42b741eecfd747fd1feef4976db19225f6e5afa945579ea7ad427"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4e8f6b409bfe1f6c1657680fa22ebf6a356d873da1d3b4063638cbcaf3dea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af15f8fe70214c5f9ee7456aa42944eed160fd293ae88be41a78ae4754791af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa562f2d62c1168d15df5430ebf34ee770d3b30d6740c8b2019ffe348e6f0f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
