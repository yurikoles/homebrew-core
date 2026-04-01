class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.18.3.tgz"
  sha256 "de53d5096137315bf8441101ea17e41d25c9f5ec526c5351d4e01d99d1cbf46a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ae5ea0c519cdbd46534528021d0d47cca8011fdea59ba119df77cb7fce10d0c"
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
