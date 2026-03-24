class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.9.2",
      revision: "5f835f17251a66b2b6a89c7ded78f2becadfddc3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0055cfb314f0417bf13479d1a2e88f87084b4b3359ec693944ad011f5790d025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8039c843c6baf50085b1bc439ec044cf78c6233f4e2c9f676d892bc2a32955e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc5eae3d7d736affbc968bb9b7ce7d76b6c584a4c6fbba791bdb149816dbb4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77c1e656da5b8f6d66040975e2ddd9f87f0d59d2348327bbd15a5858d1e7aff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e52c63d09ec5728f7dd8e1259a780d7e764ab4c374c2969f4d8317c67f6af10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0e22c8ba07e1985c9aece1ba3511d018a5b1e4129c1e60debc084caf09cb6d"
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
