class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.4.3.tgz"
  sha256 "8e9aa5283b7bfe8904d0e3996667a72ec6a5f3c73a9cb14ebd89f2cc197c3fdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d59fed5189e6961b265f26ca2b18d0df8ed5722c098af5c7db5e1a2bad12157b"
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
