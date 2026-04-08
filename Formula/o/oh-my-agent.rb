class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.24.0.tgz"
  sha256 "3387aabdf5d972eb20d4cbffe18291f4a14e8aac5327f29708116c4714c3f197"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f80db79e9f0b4835991476b5413bcd44af44e8ce37bc5ea92dd44d3e1122b253"
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
