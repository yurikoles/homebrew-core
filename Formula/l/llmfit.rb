class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f60e2d9e137004a9595806ef1682072720eee99533e4157f5121e51e509e4663"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb47b5cbded05c8858adbf6560cfff2c3d1f0240e804a381293f460e33f4fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fffea63ffba9824cf95fac35c9efc9bc165244037b00c3843abe6dc93993bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7505dadadf36d0f24844e7e40fefdc5c2e408ca5633bf40643e684c7ca11c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "97c37380408d99967fbc5630062515e613622516a300f894217d67c02a475968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f8a1f98d2b3199881899e20db4fa486d665b53205c7d1773b606843c4bc8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17bf04f74be5babfe4e1e085a8d76ecbc75bc3f0abcca32f990fb9ca3e598a95"
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
