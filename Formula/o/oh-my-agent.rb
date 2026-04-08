class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.24.0.tgz"
  sha256 "3387aabdf5d972eb20d4cbffe18291f4a14e8aac5327f29708116c4714c3f197"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22110620e49d10cd894df7e335d33080b80a4d98c5e5c90ff7b38f7b572313a1"
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
