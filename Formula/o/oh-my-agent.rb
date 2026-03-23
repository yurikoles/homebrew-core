class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.5.0.tgz"
  sha256 "6f18dfb8e8b5a606a3b14181a81bbdd2a17d88de1178297573f4b62fe6ae00c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "290b6be972522d01c7ba3bb8ef3559d40e9d42ff59bfa81c97fcc5cbfeffc981"
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
