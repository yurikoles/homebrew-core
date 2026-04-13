class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.2.4",
      revision: "e3875fe6398e96a2af0c20cd20d66b0196a0e890"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d04e64cfa3454f84fac7e66da0f81789f9f661cfeba9908770b5042bcd2e41e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04e64cfa3454f84fac7e66da0f81789f9f661cfeba9908770b5042bcd2e41e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04e64cfa3454f84fac7e66da0f81789f9f661cfeba9908770b5042bcd2e41e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "523e74b929b36649dd5c272a46d6c437c9627e996540bb313e87bb4b9364f810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f222cf3e6beb93e2883011e605fba1d11b80d52547ec63c52dc8f44faef9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66fb0753ff17fd0f04dc0adfe9d7eb7484c9a3d67e72f3883ee2c9b9db64c279"
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
