class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.23.1.tgz"
  sha256 "43c5d042605484a205c730ae9dc4f506d07cf1ec0e696aaea7ffa8f5d800f5f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c2630cb1390b55de2aa3198e411490523ac338e60ad91f9a991d2f7bcfc216b"
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
