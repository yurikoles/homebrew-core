class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.23.2.tgz"
  sha256 "84b247123a35890c8bb01282fba9c8d010e8218035fc3fe88d91a46a05863313"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b723d2a02d5a7d68683eb659e77ad8db32a3e50c36cbb834bf1ffcea9d3e6d3"
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
