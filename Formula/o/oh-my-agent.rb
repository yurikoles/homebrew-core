class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.18.0.tgz"
  sha256 "312b8ba1fc2949d14834efeeab84f9027377a0ebfa5beb4263974c18c1112a58"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95080c1d4b84d01cd6ac9132266e43363dbbcd672b0f4621f316cec9f1c0fb2e"
    sha256 cellar: :any,                 arm64_sequoia: "63f58a7459926618b5752f420a475cdbfbb36a6be80f43543a95ad4e83a26816"
    sha256 cellar: :any,                 arm64_sonoma:  "63f58a7459926618b5752f420a475cdbfbb36a6be80f43543a95ad4e83a26816"
    sha256 cellar: :any,                 sonoma:        "1846e4e6550b5ad14638a93eb11770ee14ddf31bca633c9f49dfbbfdaeb512ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a687d839773623d1882cb4fe5a20a068e1e570a486aedfd680e7211732a8011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f421671d1f703c0db9389cb124532e91c3bfd0b5dcd373a8dddb125dd7377211"
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
