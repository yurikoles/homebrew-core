class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.662.tar.gz"
  sha256 "bcd69ba4d38c21fa0963b75f5ad52fc47df9c7368f3c0c9f121c1d37888a881c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ddbe0c4a592daccd67afd9460b0b4854d0fb66d09de18fa19e43c80708979f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bace9a98956508327fca1d62e4ffe872396e42d6b7b29647bf9d17bc9dc4a5cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf1c1d2f9585709be8519095fd49acc9dd23bd4ee9f2eb0ffeb41d8827b1296"
    sha256 cellar: :any_skip_relocation, sonoma:        "a06b7bd9d6965932397b03df9e34b9d36bbcda2927926df9bea4e293a0c8fd16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7dbe6eece2e172002647c5d5f3dd6ccf7f433ea6dfc00a02e74d42762fb750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb0a4c56b47495dd353cb5e906677cf9b34416f63d9dc3121a28b71e566bb0e"
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
