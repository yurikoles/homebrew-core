class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.49.tar.gz"
  sha256 "8e271a94f7b323c12805545b637a1ac7094a0ef29fdfcb23dca7998f4bc2600b"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b879162ff6a304404652fb95df95be59bd73a5caf6846d8b957fca11af60def4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b879162ff6a304404652fb95df95be59bd73a5caf6846d8b957fca11af60def4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b879162ff6a304404652fb95df95be59bd73a5caf6846d8b957fca11af60def4"
    sha256 cellar: :any_skip_relocation, sonoma:        "115b253fbf0fb28677aee9a7e35f5e964915f331288d169d40d3305f5a70c3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b71b19301eb2738ff98b036486fef46451ab7c57e38e264279e7a5d9840ada9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31594fc11f97408c4f2007f9c6ee2481e5b254c6247378125f899e7ff9c7011b"
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
