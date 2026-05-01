class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.5.2.tgz"
  sha256 "ee50cc510334e1cff3f4cb8cb78f5b689af0a1ec853774adacc8da9391e58130"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acccde9328104091f6c495b0f20cfa96066a0ebd66d26b659901de6becc05915"
    sha256 cellar: :any,                 arm64_sequoia: "da3c0f67ba6b78081d48ed0c95516d41d0efdc77ecae07cd1d8302122e5176a3"
    sha256 cellar: :any,                 arm64_sonoma:  "da3c0f67ba6b78081d48ed0c95516d41d0efdc77ecae07cd1d8302122e5176a3"
    sha256 cellar: :any,                 sonoma:        "be9448bf7bfe52c4acf8451bddc0893b31b0be7990f096636c3de6e7b944e50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "196cee9262de8062825b9d73d853cc6301c08bbcf11bb1acde9a5ee8d2442485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2183befa90a68a94985cb67f5cedd2c6fb6a02acc1a536b3e76157f2c28ab3b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
