class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.11",
      revision: "a6cd637139f2b89dc4371e1b44ffe0df565bf6bd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd9af5ce3979a4916a81e30ca38825a879611dbba10683cec6be2fcc29f55139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b384984c5e1a4647075d5b6343a478e941ae11c7b7e69770ae09a2f8e348cada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588ca061e3f26da898215da595a2ef6fca519a59f05525e8fa15a0fcfdf4e45b"
    sha256 cellar: :any_skip_relocation, sonoma:        "474a7ca7a5ca18f0f5414e90642a65b4a6118148d3b81adc60b10675fa633a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b7164b8caa9f8af369baa0efa280800a89ae4ee8c25d36c0bc4e4187a0ec0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3b8208531a712c9cef4c3c6be0b1dfd58f87288d0eb02361e942df1ce90e0c"
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
