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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "016050d2fc9614f2499d5bba905d2c81d18d7d6c04f7a2b7a493c7091ab6b4a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016050d2fc9614f2499d5bba905d2c81d18d7d6c04f7a2b7a493c7091ab6b4a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016050d2fc9614f2499d5bba905d2c81d18d7d6c04f7a2b7a493c7091ab6b4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "25484ca7fabb4743aaf1f9f8926e84a9e54532a9ffdfb2ccfcc0738831f1862c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e5f032bae979b5eca1b15fa9ff979a9a5eede3290cd10d7b856651a319884a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a92f3ca0cdb37207df17029eb9105063b5544bdae81a6902b0e7d80e2a485ffd"
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
