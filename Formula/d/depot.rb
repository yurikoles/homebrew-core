class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.45.tar.gz"
  sha256 "0e123669a056e746c0fd77dcfa1f3852e6e826a31fb332c5b20d0222a9cf0532"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e734ad1a37f9d3f735f114b3bc84394d17ab08550f18abb5c1af969a2c22f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e734ad1a37f9d3f735f114b3bc84394d17ab08550f18abb5c1af969a2c22f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e734ad1a37f9d3f735f114b3bc84394d17ab08550f18abb5c1af969a2c22f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "05608176228367cd1e3e984db36cf3b6f6ee57b3d9110136f9ee68c90597413d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc67ff98e8b5a11e4cb9243e9bc56187903a1623fd26037962adaa520fe2f6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c4834987feb4902386c8a337c059a4d3729d161dbbe93b0a6125da85af2e9f"
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
