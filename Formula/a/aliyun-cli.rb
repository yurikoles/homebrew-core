class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.5",
      revision: "f21c29059dcfecf00107bde6439cd58fff3646b8"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b227f988d9282a9cbf7270179a7df05c1abfc27109f4c206e26b43cf47cf38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b227f988d9282a9cbf7270179a7df05c1abfc27109f4c206e26b43cf47cf38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b227f988d9282a9cbf7270179a7df05c1abfc27109f4c206e26b43cf47cf38"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f0511e89917a42576feebf3c53dc2d8d6944e8be61d22843c2ecbdef305dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe052ec1e183b787b56bf587f8bd34256842189f84a5417c615a0d3dc2c31fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcfaae0047a66f1efb3f39ea85ff798aeb9e68eb6a40ddb995f56b2b180e17c8"
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
