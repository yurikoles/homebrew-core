class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.70.tar.gz"
  sha256 "9ea98883e91b71d2d78d86c299fc5b92264e4270b14ec51e1a2f024bbea013ce"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d9115386fbafd0e3eb80e7f8a2e9f8e9398edf953eb6e862a9c21b0b0b4e04b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07df2ddb012f333159ecd65a8891be3f470c35a97cd8e977322542051d93b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285a448ee2528051ef043abea8c0c62054dee46cedc434968fee293aafa68459"
    sha256 cellar: :any_skip_relocation, sonoma:        "05690157e05d06c7942a85d4cfc2208394bd78704ee64485ea02702f14dfe9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d989bc06f6771f3d21d534b356a22c2bbb64b0f7545cfd015abf07af5cc249e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3623396c0363a1c139e96f4ef26b3e31f3b1b50bb8c33653bd7d8a2ee8f25def"
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
