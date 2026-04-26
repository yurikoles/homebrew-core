class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.1.0.tgz"
  sha256 "5e985b76727598684dfc1abd0a29dabf94633d63bf14ae511f5c466ec490bc26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab81decfc9def2bd0dd2812ae0d304e51202623cd2452651dbf965109e8e9212"
    sha256 cellar: :any,                 arm64_sequoia: "c2ce6609163253c90fab0bd4338e59d66fdd2e5a907cb37950943109c2148250"
    sha256 cellar: :any,                 arm64_sonoma:  "c2ce6609163253c90fab0bd4338e59d66fdd2e5a907cb37950943109c2148250"
    sha256 cellar: :any,                 sonoma:        "a0b5d9b3ef84da296c56e416ba0fd3b621bdad30613314ff89063364bc70be66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbdbf3294c13abf977ccb2431b41934527e3b88e3dee2330082e6b3f80b89f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4f851bd9a35595b75ba28360f2668c121f72ddaf8572bb1ca0790de93d236a"
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
