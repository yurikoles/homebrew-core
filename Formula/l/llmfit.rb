class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "bb985deec15891444b3de1e2a4215e34f5dd3b13247a3de69292bbd0bdc01812"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edfd9195843a2f3d0b27853001995d9a4d2299b7f623a927530265d9a3df27f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d8ac837c41246d4379c17caa0284655c0ec44fc63068170609083f7be45907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c995552bc4c16eed3d84e030ea3a394338e32fe4efc89ea38c56ad94b34b449d"
    sha256 cellar: :any_skip_relocation, sonoma:        "035fcd76ecb12d27e552ef64c21213e5205b54c6365448f3eef9539c5e1db7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6f05910222f59aa985011b2584db3a6ee5e2da40ac3d6459029ca514277035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fba60590d1283b3c000ee30a6ffa336e6602c37a91f4d37371da2cc6c768a65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
