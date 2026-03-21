class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "370604b5a1ca01d1aeb977870cc16d526c7d6e4803db51279979c4869707ea5c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d67180d4f10d97f0a97f8cb75b5d91c179022c5ffcae17f7945d6cf79a026d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf63d73e996825f5ee542732581ac7e0583a0a254f48f46fd26afb6904404dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f242e06f16dc84f0856cb7423b3a7173dc244456bc3d6f311b6b193a4c3dc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "f328f4f64d9a72abb736ca8846072679e953c0c011c8753a9dcc845deceee671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b43740f3adce9040df66400cf3e9229dc6422afb7d093ac78baa01f4915bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b6f1c9af598d03352b5856663eb99c06a2339f0c1620e30f4a2cbd6126085c"
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
