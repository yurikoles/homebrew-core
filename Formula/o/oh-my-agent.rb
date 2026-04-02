class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.21.0.tgz"
  sha256 "d52ca02c51ee6d8b9040ff96d4d0d785d864002596994a8e07787ccb36fd6795"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0c0611d59d07e04adcc1b171329d718415d6aac5bc3347b7ebdb23ee11ba801"
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
