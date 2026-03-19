class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.23.tar.gz"
  sha256 "e152b7249932f21aedb2d0f5aada37d5f11e81adc1f4cf2b3623ae34c80b01d9"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da012e2adad5db2709a0a09a6ca1c01d07a933a704c0c540df90b34c540e8fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da012e2adad5db2709a0a09a6ca1c01d07a933a704c0c540df90b34c540e8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da012e2adad5db2709a0a09a6ca1c01d07a933a704c0c540df90b34c540e8fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c83cc9c3a0ba8a1bb4b3801b322ca73e4a0c14738cb4b1823da5b3044ee03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5edcd8ddd7792029441a344c9e9ba8af8bec2c9f94f7acb180c40aba40b4f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f229d248daaf545c33343e7d618bea7cc237c8a00b80535f07866efba3f648a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
