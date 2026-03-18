class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-2.11.1.tgz"
  sha256 "9eecf91b96b0deee5576e1301bbcfdba3eb186067e8e1febe3b88974c0594bd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23227ec9f01916230316729a4b2f59a5febffae6ec6c2ea2b27cb00283ab96e9"
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
