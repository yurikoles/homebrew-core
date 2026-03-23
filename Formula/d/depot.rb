class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.28.tar.gz"
  sha256 "00a452a4e69d6000a367e2f44a3367ccaa04808acce771a11ae51123c9f82ece"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ac73e21fc840b1eaf860b8ada536545cdba33763128266c6a17d7ae1ae442d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7ac73e21fc840b1eaf860b8ada536545cdba33763128266c6a17d7ae1ae442d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7ac73e21fc840b1eaf860b8ada536545cdba33763128266c6a17d7ae1ae442d"
    sha256 cellar: :any_skip_relocation, sonoma:        "460812e2b93486f19e18d4c0e2f5c464d49787abf3530ee8a01d3059f114af9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a657af104c719d7651557802c9a9a1bd402553679a8b7b124a8db74518544c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527e87fd74fb1034302028f48ce01a57c52daf27a0127605beaedac556dbfd57"
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
