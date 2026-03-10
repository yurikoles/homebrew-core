class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "ca19772378422756c5ed2212e228986cfc5e791695c5025317b58fa475d4c427"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "978eec15b5e031579b3773a6b738b36bd64e07273e4bbf2f70b51711edd71646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb52ee438bf8bf8c35a7e696a484540404cf5b4f45d24a5a7d2e78b6999be90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903b8a43877a9d3cc275f2c2cbec30aca2297cf6510f77b00adbdd0313313a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "aee3563bb368fd297bf1c22e4a30fb10afdba8e71aa5b753da95497c6b2d6e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c206df245f241ad904dd1fa360bd5a818b2c284da7d0756f80fada30eb7bbcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0989d737dc7bd1f39ac58dee9f046444448f6f86f9d59aa76275d4f2b9efa2"
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
