class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.17.0.tgz"
  sha256 "45fb1829c1c6f0e887f7096142423097a71f84579fe7098a58a28f13b347e60d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c2bc0b62d6a90583c9fa0389196f589c7cf2ee7b8bf399b9ff7f465d3668e5e"
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
