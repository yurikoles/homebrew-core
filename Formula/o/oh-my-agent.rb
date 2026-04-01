class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.18.2.tgz"
  sha256 "3e28045e68cb4aad9f811017c2e21ab5c20149f42018c88f0228d1745b1b7043"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5f1feb2ed1a8641ae6a2219a928f7ca09c0730c4b6d5a23d09721d756639e8b"
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
