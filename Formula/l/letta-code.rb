class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.5.tgz"
  sha256 "6c4d1f3d4abb0c102f566f61a997dbf8d549cb30995a267b46e5e46441057878"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16f854b8e217c5fef041cd496c626f6ad0d07581854f4b0616d23a08d6c53765"
    sha256 cellar: :any,                 arm64_sequoia: "1089e1b92d398b11ad872e4f395381c7900f9f809419f3d2638701290c35503d"
    sha256 cellar: :any,                 arm64_sonoma:  "1089e1b92d398b11ad872e4f395381c7900f9f809419f3d2638701290c35503d"
    sha256 cellar: :any,                 sonoma:        "7d6d2e75902b5f30a1b6d180632fca79b4cc1d7d55bb72d45535808addec66f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c7fb372259a0170db976c5452a44db5192345c2dd202fd8bdf49422431347bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaee41dd064baa45a485715af37194e0321314ef0d4aa8ce8ed728e4e03edd49"
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
