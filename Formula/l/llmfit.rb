class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "187bb2f5df15faad7eaf049742b474e0433561277340b7556043a57505af2d89"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc24ccb9ec84e40158c8d2f98662861c33c3e61307746e446ed627c8ad44c4f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44679e172c98756cf5e80784c2976c0058f3b8dfefa640073132812531336d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685da6f2a00c555a735f49cf49135fa896dafe1faf9f116ac73fa735a04d1987"
    sha256 cellar: :any_skip_relocation, sonoma:        "217ea15da3c047347e86437b048a7cabe8611f9faee8642b3eae7bc91d770cf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5adb6200a85b74c39c043970b8d19eb50ca4bd9bf08809f1839892e14c684962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795d72ce5f9240b131ebe8c7869c3e998dd0b8383d4d41820422df7aa89ed8d7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
