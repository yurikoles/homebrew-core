class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.2.2.tgz"
  sha256 "0959f619aca434b749e0f7d81f2f6d7ee9fe8f49b68a835b816a62a004e5d240"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4db1af9715761af7b8edb46581ddbaecf12a990d5f08b35fac1611f463da44c0"
    sha256 cellar: :any,                 arm64_sequoia: "c14390c693c73e82906aa298dac70613e93ba84a81c85167b2fce79a60a104aa"
    sha256 cellar: :any,                 arm64_sonoma:  "c14390c693c73e82906aa298dac70613e93ba84a81c85167b2fce79a60a104aa"
    sha256 cellar: :any,                 sonoma:        "ccd18bdae35cb30c70b636312c448c6542e3f0f254de4bdbb6b192dedd8a0ec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5302cbb913bef2df49efd81fb5f287911285d5f3a8f3a20cbcf87ff3cdae61fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61d7b7b447fb60149419037c249297cc5f8a589780adf25263913027720667f"
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
