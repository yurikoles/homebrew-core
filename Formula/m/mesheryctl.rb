class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.14",
      revision: "4677f20b43d383f1d3961f4fe1232615873e563e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72140eb7fc8f2bda3760b2a59f970912fe8ee8c97fa0466986138689144bb439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fd0dca8f71c34aecee952b12db6482125d4ab35f130539f9873902d227a7988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07fdd5956b9414cb30271263f7d1dd0ca4a7d590ab4f547f8a32c4e3b55c934"
    sha256 cellar: :any_skip_relocation, sonoma:        "f39556b12ece91ab6336f065c9bc3d6850e93327647427a3d982b30f494fc1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d53ff851caeb4f5558cda111ae7cce8ee2f01035e0d07f507ffd697f983efa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60f1f4857213512f7590aa2a343239864f66d949f00e4d7cebdeba9f6486b32"
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
