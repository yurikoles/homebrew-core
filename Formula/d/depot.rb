class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.20.tar.gz"
  sha256 "cfa0a415f6d1986465685ecddf98c749fcd16bbd3699dee3e4180feb914e4008"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc901004fb661d57e13f137f783ddce89ec9a163eb509d2929a22e9259a6fdfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc901004fb661d57e13f137f783ddce89ec9a163eb509d2929a22e9259a6fdfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc901004fb661d57e13f137f783ddce89ec9a163eb509d2929a22e9259a6fdfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7fc256f6af747ddcbb8c48068ce2f665bf7c359c408d4654cbdfcf890116fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d931e0b58366521f64102a7bfcb61581812c5d63ae41edb803f3a2987f614056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c45528fa5d846847d0c4b8618224edee3ae5cb48564d1e6938f4c9e035350e"
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
