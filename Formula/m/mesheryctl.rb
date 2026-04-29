class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.15",
      revision: "d8cc10878de419e50d1ac996d001080935b0e1c6"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d2ecd7a64cab0149e8cee7db027ed65d095b4f1808459ef7136e7958d6ba56e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52d0021e8057365cba36ad3cf74d5c864dc55bf4a54f3819f82c7d8bfa2ab1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba6e51cc5d90c2248e8a858dcf61809dd09450d944bf577f1ca92dd2a1f1285"
    sha256 cellar: :any_skip_relocation, sonoma:        "654749938bed1860d515db2126e3401381d0909517907ccd916d33a5d9ea607e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40855e2b1b96c8551ddd6d9a1aa32f988142e89f5919b9931e6c90db574d3f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56e2931d81b48ec77aec398d366f987068f5b80a279979577e32eaaeef994af"
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
