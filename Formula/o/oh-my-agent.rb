class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.12.0.tgz"
  sha256 "405fa90eb6c25bb8436fe0ee4f56ea56d3ff1fe7a9d7833200749bf4acefaaeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4fcdaf84a57190856a1c9f710711d64279707f57a74d53e23fbd555f73e27d1"
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
