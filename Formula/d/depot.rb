class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.17.tar.gz"
  sha256 "83ed64a793904e399ac8aef631d22c0006b77305fcc99c4ed9132fc5f5fc3820"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a6d6b8268856504b5db27fdcfc12379a2a36efb3c4061715f07d7393e4eb17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26a6d6b8268856504b5db27fdcfc12379a2a36efb3c4061715f07d7393e4eb17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26a6d6b8268856504b5db27fdcfc12379a2a36efb3c4061715f07d7393e4eb17"
    sha256 cellar: :any_skip_relocation, sonoma:        "553dab70984595a0f90612522d6bc682d417590b9a7db11231f5ffc8619acdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca82cff6097216faa932447b153c93a156d14f7103cac6431878c32ea0f3d7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a387955c8dc515da120ea845057945bba1ac8c7be5359d845bb276737d1ba6"
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
