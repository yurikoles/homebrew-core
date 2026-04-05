class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.23.0.tgz"
  sha256 "318eca4ab0f70be5841ea19abd860292773ab88378dd6b2b973cb5205893bc9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ea6fe76e680aa6f3b5fa78c4f4e3c04500c32b43fca7a7e537e60f8bebe7906"
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
