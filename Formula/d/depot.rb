class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.22.tar.gz"
  sha256 "196ec8e13fcf81df048e335317377053a52b439d7d3b3167f8e5415006fdf01f"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50ec383f2f7ba36dc8b4b120eb7aa423c4520dfe5ad0916a9591422420705b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ec383f2f7ba36dc8b4b120eb7aa423c4520dfe5ad0916a9591422420705b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ec383f2f7ba36dc8b4b120eb7aa423c4520dfe5ad0916a9591422420705b6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4cc9d50046a00eb721ef644c27291b3584e388b75d3f9fedbb777f9c85ee16f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8434bd304546fbac1d52aa7caf6b42aadc285b8f2404cd5232e6095335e4bc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce77af78f6b5eea623bd672178fee4fbb97784821c029feb60e095a6c408b81"
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
