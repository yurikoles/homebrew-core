class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.50.tar.gz"
  sha256 "5adbcdb393b48892ad06504c0f0258f9f612137814bf1add188bf1ff261bc884"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9e84858a3445f229096dbd0f80153b328b29d245763f3685644d78599de0df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e84858a3445f229096dbd0f80153b328b29d245763f3685644d78599de0df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9e84858a3445f229096dbd0f80153b328b29d245763f3685644d78599de0df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e13887b53d6cbbcd5158f3b584a423f8bd244c699a613b41066588469d4e6d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0695c5ac87cebe76c201df4724c13df3df8ee0ec4b6a0b59ff813f4e84ad208e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6924e43feec160df76a10e8e4358783fb4b5f5d635539eed75a82005284f75"
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
