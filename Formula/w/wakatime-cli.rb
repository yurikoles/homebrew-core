class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.10",
      revision: "e94919d0302fb6cb48380020d64763f4ae43017f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b4938993179a5b14e409c884d0a83c7ccb54384fd20f8a6825602af921438b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b4938993179a5b14e409c884d0a83c7ccb54384fd20f8a6825602af921438b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b4938993179a5b14e409c884d0a83c7ccb54384fd20f8a6825602af921438b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4d0133576c3da30a1a1fcf96ac5ff7d1e388b2d3abb12247fa30d3b4c443308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a310aba2c1563af9c2b8a0776f7e3104d4b6785956a8e5dfea72e6abecd01e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15daedbafb0fc4814f5e70b1367c904476e9dd03e1bae0edb5afe7856f36de38"
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
