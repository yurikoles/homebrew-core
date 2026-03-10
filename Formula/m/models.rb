class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "e7b7955c6288b31c95ca66838f0d8ba129de8259a3ea65fa8044b32315d5bd2c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b452069ddb953453143f17673df55ff470d0ebe6280e131d1cc2f31ae0c36221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a08b6d7cf8e1bc69dff881aeccac0210d0b35103815d287654445d088703a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8235326a30b62ff5eab7f267313194133f0696acbadd5abf90ff9eafc6c941f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0698e722bdb03b7dce42cfc5ba5e1ebf761029e971f78b0975175fe822ae9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cf15db6ac12bd8ff1c0c85ec697ded41372a6feea9417f3b3ef01178e28ca18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a764b08d36e05caa7f1d399b4ed518f166dc00267d09b5890c5af5c75088f3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
