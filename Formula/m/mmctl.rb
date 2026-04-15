class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.5.2.tar.gz"
  sha256 "6763d56b90bbba761e46f2d671a2eaa3e3ef4ea6d1eb1c53c41b275eb1226f6e"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c6c20fc29bcaafab7f7c195e8e47b4b767f16c0dde42f6f63c0810e03be4707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c6c20fc29bcaafab7f7c195e8e47b4b767f16c0dde42f6f63c0810e03be4707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6c20fc29bcaafab7f7c195e8e47b4b767f16c0dde42f6f63c0810e03be4707"
    sha256 cellar: :any_skip_relocation, sonoma:        "06b969313485e4702fdd4d75faf8a68315ba0a1d41cdc140903f6e87bef17cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb3754dc6cf264ab5a59719484938a37f57158aa465e4b331d61b3bd03f5c62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca3399649db125bd0a2a96900215bf852e26d3ad04540e681be1060680ed8e6"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
