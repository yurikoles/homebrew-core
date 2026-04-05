class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.0.crate"
  sha256 "d91cf104c40aa44eba015a8637e7ac181843cc44c70f75040295c22da9645323"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cbc1d2eb551a75663a67abcc1868055b3ed6a2d42c6e11c8d60fa46116863e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac0afdf2ba9705120ddb82fd4ec12b0e4a0a00e1b8f59ca36d9ef604a771e535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9c87d9a3da41c8c80647aed0e4ceb9e1d5b16d4245452406d688a4c9ec4c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd4c1a8c3235871c15e7eccdf6e54a798890d12e64e19cdcd8fff71aeaff5bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ef4bf43a7036c06dbcc09a6ca691326b3ca0f2bfd4daeafdb66a220193a528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacc60fc250f95237f0d8a2823d5d9d1a425d2d97f84b724a5165c1bda157335"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
