class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.2.tar.gz"
  sha256 "96782b2205c412ce0fcdf2538ddeac166a86c1ed907bebb5991b5dcb65c3e34a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed4ef9874652a26fb70910d3d3c9a461e05fea0090c2e9b8da1d5010383d02e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10158ad4900d6a9c3168cf705a01da6266d68d8f2e18e18113118c27383d33dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55ddbad56fe2817bfc60cae56ffeb027baecd9a8baca9513dfe03e91437adc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f2a6c56c6ef342d3ed36118083f21bf4c1570ca5eceeb275e90fad0a093c94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdcd9a4d767be5a165a3458e79e907094ed7bff04eb15fcbb217bd7e3de036a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070a0949b0c72b64459fdc606b22fbd43fb3a6f4bfe3553ab1ad16dcd6a0ac96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
