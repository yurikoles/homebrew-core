class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.22.4.tgz"
  sha256 "9e3c0f58de4648e762797a4d907b1eebcbf196964b421bfe3611bb0cd2f3c2a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7a06bb10a5de35e210e5365f848d153bd5fe9232f0c5d7d5a805dbf8cbbd2d11"
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
