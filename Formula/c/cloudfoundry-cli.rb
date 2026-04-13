class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.18.2.tar.gz"
  sha256 "24cc28199b9f86806e67bdeb812840e4221da2fc283cb120eef726f08a38e3b6"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b886c895de39eb2c9a2084091c647b693e07c60e4c9bd2b9e1eff7e96f035946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b886c895de39eb2c9a2084091c647b693e07c60e4c9bd2b9e1eff7e96f035946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b886c895de39eb2c9a2084091c647b693e07c60e4c9bd2b9e1eff7e96f035946"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cebd30dab4e0def10337bc7d5993f6db791e1f9b019d4390344bb8ff499b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf8b1c314dc24a44619af8221b940281fa442897b1ccf7bea1638fe1025994a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a658cef484d912514032781a39669db6c3e20cd05c3189ac2c3b43b2387c71b4"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/v8/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/v8/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/v8/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
