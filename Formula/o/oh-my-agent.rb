class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.27.1.tgz"
  sha256 "01220c0bc6a6e0ef78264f780e9e254ae4a07e7e8546cd3034c39dd3a3d041e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ee9da68a3494c9e96406334ce8aaa3a6ff1f549ffa725ec49b7e5a850466a46"
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
