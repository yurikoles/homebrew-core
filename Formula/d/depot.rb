class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.31.tar.gz"
  sha256 "e777c150bb5664475ae3b06be3dafc590c859eadff5f6d80fbdfd4afad8496ce"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97b026f94bb42be3188df38d6fdeba0aef2026ad60afd300bc0cdb01923003c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b026f94bb42be3188df38d6fdeba0aef2026ad60afd300bc0cdb01923003c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97b026f94bb42be3188df38d6fdeba0aef2026ad60afd300bc0cdb01923003c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5456e606ef734477a815b8fdf642c699220c8569eace935c7b61a721198fcde6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a900524631089283da1d5a10554844f7166ed84fe5a3b10fffbd1819c7ab31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f0dc5480ac91b6740b4e529d7cdfb8c5f7afa76e09ec6a14527729abf47322"
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
