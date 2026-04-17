class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.6.1.tgz"
  sha256 "3dc45474687bebd00102d0d9014e17a24ae690d0765c591d92f6a71246f9c867"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ca11d8a6558a41fe6391c2a46b34c1307ae37c27c84f4ebb5b5b50bab063b54"
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
