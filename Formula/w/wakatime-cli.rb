class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.6",
      revision: "9b17457cb417411ee0fff3a37322de92984ab3d6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d0da97a298bfb0ba446fe679dddd2d1308e0e25c71fa55bbc3cd647f8419d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d0da97a298bfb0ba446fe679dddd2d1308e0e25c71fa55bbc3cd647f8419d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d0da97a298bfb0ba446fe679dddd2d1308e0e25c71fa55bbc3cd647f8419d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc2b255db3a523abff152f01c7e5ce9c37b17f78a48d419fd49e5e869eb57a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1933f2cdbfe5f389786591c90df637457f631bcf0c152934f3d8150f3b35f2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b27da84e10e48d058ec8dbd3430a8444d3a9a3733b8f1d6672fcb94a866865"
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
