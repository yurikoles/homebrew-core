class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-2.10.2.tgz"
  sha256 "b0ddf8aac3da51dee59c5df3f5cb7d88bfd8c8c8c0242b3d1b6e1518c1362985"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fb46a220bdac1ce8b0ef27ee36c7bc7d06a2ca6500f2b9d7a682d96e5482bd8"
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
