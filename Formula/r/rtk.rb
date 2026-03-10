class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ac6ccce24d5a6db952478a3cdc82098dfc0a208960233e883db7f4aae662d099"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29798f6cb6f84c140ca27525b5d7328013dd0d7efaeeb001989af3c38e3ae065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db6bb43631dde7a7abc17cde0c4bbeb67a8467645567c39aebd51415aa436a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69282f79a5bca22da634783322b9e94ebe324c63ade4277e68bb71bbb016b05c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b005e0c29ac51038667102517db748cbe71594b37983531da70fb21681cd6d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f4bddb5eb3cb31f8c2d42ca0dcbd33585cfc407e8cdb6ab9f90502c351b815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b4a982c9838a2d5ae89ab7e19852ccd6207c500eeeff6c017135703cffcbfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
