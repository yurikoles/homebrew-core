class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.35.tar.gz"
  sha256 "5fca59d82c48fde468d87f4c5f25bc76f02856ac37b57507f91d5434578332f2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a7e8e0b302bb6a1997d3b25ba09f9d9a421afc4b9edf4c54eba11749a2532ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a7e8e0b302bb6a1997d3b25ba09f9d9a421afc4b9edf4c54eba11749a2532ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7e8e0b302bb6a1997d3b25ba09f9d9a421afc4b9edf4c54eba11749a2532ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec7e5f036d5947848b6d649cea42654bc43aeca5f5e067db5657c283f4e41d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e0df40d47881e3b190f27b6f8549dd408b3a0f1d4016aca52bcaf45b7be53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335f89ada4427d3696820877ea6ae013d099f2aa9819d8bd69aba3e34c1b9f8a"
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
