class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.1.0.tgz"
  sha256 "5e8056941a34f9b82da74cfbcae0b03bcaaf6e52443b228378ad24b4e7b30e40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "033b64e8ec6f959ec46cb723003f3f9ef7997693338ade6e35e455c2fd1b3ed4"
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
