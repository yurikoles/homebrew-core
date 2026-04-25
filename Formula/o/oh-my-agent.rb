class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.18.2.tgz"
  sha256 "91e747adbdb10448cbfc4660908c46449f3d12ff3254250828d4f5402813c898"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38fcf4bd5a2db0cebc9b7ec3db448f1c0d71b8e6e86922521bfb26a99c93da17"
    sha256 cellar: :any,                 arm64_sequoia: "31927ab5213c1d02d44ec55db88aae0c0cc7749c3e57fb45602a4889e1fc796b"
    sha256 cellar: :any,                 arm64_sonoma:  "31927ab5213c1d02d44ec55db88aae0c0cc7749c3e57fb45602a4889e1fc796b"
    sha256 cellar: :any,                 sonoma:        "6bce4589f3410f75cedd8e09e3b778ed07bf39d8a926214b0e83e1764982798b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c45f4d616fab1d342c560dab2a54a359a9dd6f0ad16b2fc98841b81e991bd36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3c024e93617310b6f0149e0e77f2b0551237cb5a25bd0c8f47730b4f53e84a"
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
