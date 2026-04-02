class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.1.2",
      revision: "6b30a5333992e225ad6c19acc19a1f9e1ac06ea1"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6b75d691c468c10490ca5162d351085dd35e877eaa8c50ea2313ecdc8e20ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b75d691c468c10490ca5162d351085dd35e877eaa8c50ea2313ecdc8e20ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6b75d691c468c10490ca5162d351085dd35e877eaa8c50ea2313ecdc8e20ed6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba425465015da035a3d6b89148b840ed77ff69a9ffa766584fff033e68e6c5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc41155f65bf9cd470d1987c5b55f27e908a08ad92391fb8a55330feaf484a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ffab7afeea393895ecdcfe6ad89d1c84e1ccb17eea97665d6ac0490384f457"
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
