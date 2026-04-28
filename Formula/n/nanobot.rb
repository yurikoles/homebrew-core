class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.75.tar.gz"
  sha256 "4b9c9452cadd589e9bcc5c699a5c804dc536afc3358f15add60b98563972667a"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e144fcbf106e92204304cd9bba6a64e885763673b2cba7923edd57a14e6c5649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e996ef0b5bb4f6b0a081ad76f80e37f0f348ca170fccc36b3812c20a59edf4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3354dd73e5c098e292bde449fc06f68fea98bce0d53830c580bb4101d32a14d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca8ad08da6adbe703952ba24430c65623b45ba5d476bd37267139d021aad05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51978c4f17a0fe714160496b849526686c03e25b1a4d5ca39d9e24cccbdd88f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b184cfddf0c46d477d3ca4e652544dde2f6254d89c5db0a2b52d4d6e0c55d8"
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
