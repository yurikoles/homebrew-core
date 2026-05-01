class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.5.5.tgz"
  sha256 "9918488dd2b7041e14b8f2225a6aa2b061e1c223fdb010b49a5af161a1e9d2d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9963dff012a5f3c049e471cfad4bd70339ebcfdbc025eb631166cd1aa185dd9"
    sha256 cellar: :any,                 arm64_sequoia: "1db31ce757d6f8efeef8b9e780695aad3c1285f6c9ac2b82bd83997c155f33e1"
    sha256 cellar: :any,                 arm64_sonoma:  "1db31ce757d6f8efeef8b9e780695aad3c1285f6c9ac2b82bd83997c155f33e1"
    sha256 cellar: :any,                 sonoma:        "4b5f7efd732386b6bea649bea667e5157027f169c93c299d6dbf1202d14c4f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4965b1e217111bcfb64ea31fbb39d4b8624972b13ff73aefd3d42792d5c2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "717823ad1a21d26964d67ccd82a8bf331efd47ccd4ab4ae64ac8a7066e185a6a"
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
