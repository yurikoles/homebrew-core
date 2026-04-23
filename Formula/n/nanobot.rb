class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.71.tar.gz"
  sha256 "63769921a0dff80a2429a9c4799718b5323ba4354e995eb65a1a1a5eaf57162f"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f66928e6e7cf9ec5c9a74873330aeefcf98d5c299e80923f3b7d74fbbee3aba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ccfa15edf9748a7c9e33a5927f095ec334d5d6426520228ee3d71baf5feb35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6e08ec9763069c8a79f9a86110a71b13e8fa84feeb3591da2184b630fbac97"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e16e0ccbf4c89431320c759d73891c39429309bc73d36a8553ef146adaf5348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b01ff6511268f8330db9be59450f386015033f675d67b7ae2e8e506797747e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f2cb69c2a7a4b6fb14b34ce7da83a8a47054194860fcd541b883593457a056"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
