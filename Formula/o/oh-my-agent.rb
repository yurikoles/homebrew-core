class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.22.2.tgz"
  sha256 "d4edb2c66f5e2e137ef1a2a45942e68855f27f703eb31b3a7db0ecd63bc0ed55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb8064c874f41df0cd166eb06c086ce9936d9a38fd457fdcf891439332debda0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-ag --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-ag memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
