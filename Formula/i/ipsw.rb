class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.663.tar.gz"
  sha256 "0276ebdbfd078e8495796985e9010af45feb3b30c595a0554b638333380f8d67"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f349c6d2c7cb3a99dbf765993220f65e28e794d6bbce84c2bf277f02c4da1852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd668782d6818c7d5cf74aab4a46ffb64b0d9c0275faa4c7332f79286851420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da2129da1eae1312c3115e7416d488063ab14057ab22700398205c3602c6feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b41f9c540c2ec10a91ac085ce2c45205df1a9adf019920e6572e618cf05ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b73b84d2e7bf9da09a71e629b76ac8183614eb9849ebc28d178839318676fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e579d2a3d4e9eab9c1f58cb9fe3dbe225825a0a9c6234afd7099817fb115000"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
