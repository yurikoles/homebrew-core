class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.10.3.tgz"
  sha256 "25f277709abfaa7a3587e2fa057090fe382437fce7d9b396d7f43d8394838e44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c7ea13d36bd387adc0dc8153c9ea3720ebedacc6c854aebb149bc1d7f5a68eb"
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
