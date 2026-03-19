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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9944859554f60ca752fbb5492257d62df402242328f6fe3f88639a1e05d44d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9944859554f60ca752fbb5492257d62df402242328f6fe3f88639a1e05d44d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9944859554f60ca752fbb5492257d62df402242328f6fe3f88639a1e05d44d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16fd5313b60958adb865ff82587f0de235d2c2be8e913ce645131093057ae33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f43945c91999292e89850813e503c9c99e9e27e65f244e058e7b4929bde0940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85893544167a8b24162bdb7d897f17595c89087f9872587268615cbf6fe0a14d"
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
