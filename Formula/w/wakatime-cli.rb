class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.9.3",
      revision: "7eda9c641a5cd30e7b25160e8a94d431e952d4eb"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff85d99a1700339eda898f56a88fcd527ec14877f43fe5eb5487bd89147b0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff85d99a1700339eda898f56a88fcd527ec14877f43fe5eb5487bd89147b0c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff85d99a1700339eda898f56a88fcd527ec14877f43fe5eb5487bd89147b0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ebdc40b46b2d62c40f4ead28492db8930367148409b74413d6c548d0017145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53f75e0b44852629de7107fb48bbc8c8c49568e25917f438ce6dac232b73300c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0f5f994dd89105e9e9ae5e1e0998ebbe7f985d71cb9f0484ebd653c82c8410"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
