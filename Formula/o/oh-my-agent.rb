class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.12.0.tgz"
  sha256 "5500f662d28eb6d3434ff7694dd6f81aee7aa7f4409b2bb10a52795d58f0ef7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "933b385030c64c8258be2b132d51b58a25048b7ef8b35a31e8da02269bff324c"
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
