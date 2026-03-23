class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.9.0",
      revision: "49b72e122628d2998556f54a844348bac3875842"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "157674a6af79ea9d7e452d1765e8f595fa00c7db43057422d0b4cfca840ca872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd8356d88c7caa54d63260bf9b370bd05a3a53a3559884c7941c4af3f584009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef202700c00ae4fddfaa559e3434f04da3a15256ec820d21dd5540048093b4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "86a86f9d9042dbac42bf5d8b4b0023ade5791cc6f590674216ebe9c997053bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0851045b8c6790b00a9e9ca3edd3ad2050342b8814c9cdf902b23f6ad0e62882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132a5cbd04545728ba76a4c7c8839ecd4eba816487b7132d14effd8539ac63db"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
