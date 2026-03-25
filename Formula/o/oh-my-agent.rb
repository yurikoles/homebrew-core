class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.9.0.tgz"
  sha256 "1d18c92f68a44d06fbd5784697a9d380b2b1322ebf8a80a37a248e32e744bcbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0388807ce598c16e405d2231c0222a32eaf554c8b9566b6a4147a0d55b775d6c"
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
