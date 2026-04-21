class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.10",
      revision: "1146457cd90f3cb685282e0deeac268088cf3244"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4d43c8a9a57bd150967b7e0aef74fffb3479cc9be33130a8951be7744357eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4d43c8a9a57bd150967b7e0aef74fffb3479cc9be33130a8951be7744357eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4d43c8a9a57bd150967b7e0aef74fffb3479cc9be33130a8951be7744357eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47c1997a625bb060674c7b675eab027d44a1b68c459338411646b92ef280471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50a5daefc585a0105e988286f570899d823083589bcf5bad68c3dabdc21e644e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95883757396e67917851b1648afe1b76eb2baa11ada2e76a8ca0e1d33259928"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
