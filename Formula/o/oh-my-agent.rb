class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.4.4.tgz"
  sha256 "6b0808b847d9df15e1bcfbd6feb6a2db9b68340733b87fce6aca330467653978"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0824a07ad044dd56a5c899cdfaf6a18966dae0ee9b0f41c242984e9846dc40f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
