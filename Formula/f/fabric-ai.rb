class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.390.tar.gz"
  sha256 "9bb0b7fe4ae195dc743bb7c3a465fcbfc4b2e67dca29a53bd64b3100445f0a60"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "240ce20535f5fba2f8d34398683347d4dcbf77cfadb707b1263b8f7f812de625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240ce20535f5fba2f8d34398683347d4dcbf77cfadb707b1263b8f7f812de625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240ce20535f5fba2f8d34398683347d4dcbf77cfadb707b1263b8f7f812de625"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d688a3c9e127f0a14feb06ede92258984155bbbf1cd0717fa31038c69fc5916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99492a06c13381477542af97989d55b6f192a6c2d6fd01e8d8a038d7a1104c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e954e1f1874754be63a19b843f6eaa7a2ea044cc8b0181a14c8c9c811610dec0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
