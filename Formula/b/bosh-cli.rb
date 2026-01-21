class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.16.tar.gz"
  sha256 "438d8b9a6e4ab1734de8babc95d1feaaad59c73771224a9fe150806450fcb0c7"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364241ea84eaa99e11fbd16cb9e2a67455f9f46ea9d30a3cf5231bf59c09043e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364241ea84eaa99e11fbd16cb9e2a67455f9f46ea9d30a3cf5231bf59c09043e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364241ea84eaa99e11fbd16cb9e2a67455f9f46ea9d30a3cf5231bf59c09043e"
    sha256 cellar: :any_skip_relocation, sonoma:        "58dbfd06394ecf749429b5b966e69afcd7f2713d8103af0ab56c618ac8e7109b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3237a5c29d5512934a160a415ca855de71afad1c050814101d834568b102283f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b031d3c6e14a2d3636706a8493419fa764b8719e9a50e690afdba7bd141ede5"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
