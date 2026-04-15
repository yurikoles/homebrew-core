class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.3.0",
      revision: "eaf4827871a685bd1e0d0ce5db3e2604755f1c3c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efa29c3eee30ad6c69a9330858b7042c6071df153b4bad61517297e2048b65d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa29c3eee30ad6c69a9330858b7042c6071df153b4bad61517297e2048b65d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efa29c3eee30ad6c69a9330858b7042c6071df153b4bad61517297e2048b65d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ad3df4ec6fcbeebd952cbea906da7368d0163de251be791a4ca6ab78f401a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958357e648233b88742f981ce1152259f6c36862df4d183b38c29ef5511b46cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9583d7e3e403297f7d68acd71b2bc41d9ca25f2f4556fa3b163ed53c4e76816f"
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
