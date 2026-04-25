class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.18.2.tgz"
  sha256 "91e747adbdb10448cbfc4660908c46449f3d12ff3254250828d4f5402813c898"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8823d8352f58e3f7e7c55283262d95f54f6d5b110e59242a680d19905f89552"
    sha256 cellar: :any,                 arm64_sequoia: "8ca6cb30b6409a1e0ff6696439129a20986ef9380efcc248186ba53841892f97"
    sha256 cellar: :any,                 arm64_sonoma:  "8ca6cb30b6409a1e0ff6696439129a20986ef9380efcc248186ba53841892f97"
    sha256 cellar: :any,                 sonoma:        "cc2d0b15808a32073b6f471686feae4829e5f7fdb94b757a6daed87147fdb9d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2de87877d586d4f700b81f335629f1a1b2488f35ff89ff712e39ea721aea340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bfb2d9198e0bfb66a93766c506c436946b7ae2b36ce5ee17f38a2bffd2136e"
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
