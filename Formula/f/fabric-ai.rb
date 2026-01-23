class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.388.tar.gz"
  sha256 "5335989bce4d962c5a2eee86f2fe02c994e7b25cfba57fca8f07498083e81735"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a77aea668a2321ccc0bd8fd345d60e7e841574b498333d29572d3901f4467eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a77aea668a2321ccc0bd8fd345d60e7e841574b498333d29572d3901f4467eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a77aea668a2321ccc0bd8fd345d60e7e841574b498333d29572d3901f4467eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d88a900cf3d876d2ae21261a382da6274354eb7160c7e3464ea0f2e4016f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb76eea618010eec2b928cb83659d609019a9303182b57cfdd5fa3d25296168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e05d4e41afe2b33eb1dcdf321965ac83b38e1dbfe6542489041689c9364054"
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
