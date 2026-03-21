class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-3.0.0.tgz"
  sha256 "8283bb4acc8bb963869a3604015e3b6e04de49cf7af31039ebbcf2889b76754b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b5e61715096e1d2edff9f9d50c2237db86145b2d10b25742c97463e7c174f3b"
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
