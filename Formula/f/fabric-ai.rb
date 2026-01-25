class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.392.tar.gz"
  sha256 "51a164e007a206a685c947fe78cc764fd757224ecd4bae627c6504612883192c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c740edaa4fda1f846438d25eea19dc8418691dd0f63881ba8d6de110aedad478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c740edaa4fda1f846438d25eea19dc8418691dd0f63881ba8d6de110aedad478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c740edaa4fda1f846438d25eea19dc8418691dd0f63881ba8d6de110aedad478"
    sha256 cellar: :any_skip_relocation, sonoma:        "203be6a81b832f00d9f547b0c0516e82d8edc830294303f4a87a14b1ad45c82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408be3890bddf71c30c8ac67027a5f345e4376de9ad7f8fffc8fb3bd7776be4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a018dabc916767cb1bca41c33a6ddbd64eddb979f65b609d570555a4ad4c1548"
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
