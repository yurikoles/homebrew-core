class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.4.tgz"
  sha256 "dd4f238d256c1916fda568562a7af6505e95448179d0dfd339dff5c2b21bb087"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f09714dc3f89b7161e62a3fa3c814684affdc1f705c4fd16aab7f8bf31cb7212"
    sha256 cellar: :any,                 arm64_sequoia: "098a82c02ab4167842d1efb552fba9f41908b889e86ef9d4c6062f66c171b62f"
    sha256 cellar: :any,                 arm64_sonoma:  "098a82c02ab4167842d1efb552fba9f41908b889e86ef9d4c6062f66c171b62f"
    sha256 cellar: :any,                 sonoma:        "3afbd6caf610c2b851faf2a52083c53a73028d1b7b79aab9cc28be6771ad3c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b5b715f966f64238410b5685127c93835ec17338eb7f7d7a97f03db853e61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b1a71ae67719628f228a21b86474571792e4eabfdffa15b3b8b0613c78d7ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
