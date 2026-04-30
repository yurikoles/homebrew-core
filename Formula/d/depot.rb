class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.51.tar.gz"
  sha256 "661c926f790b1e4fb23b21665a3e7805f0cac6601c41eb58239bdf6cab332b3b"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9518b94d7f30d46a1047cdbe5333b5c71edce95b175cc4bcaf61eacbdd18b262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9518b94d7f30d46a1047cdbe5333b5c71edce95b175cc4bcaf61eacbdd18b262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9518b94d7f30d46a1047cdbe5333b5c71edce95b175cc4bcaf61eacbdd18b262"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e0dcb936498a74805a1716af75b5c8a6e81c9a83236bcb3167205a07523698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0b119f27033d36b994c2bc2946fc2fd73fa7eee0d7a0ec51eadb52df0fa05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549af190ee3b275cd6ca555033ab300cf49c720bb9a1542a4e92ac8dbf81f005"
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
