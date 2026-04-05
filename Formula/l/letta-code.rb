class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.13.tgz"
  sha256 "539e149e74b2eccb104c286ec4d56d65d04143dc0663118b328ee709c9df0048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b83d92b966a5a39477a4c5f20fd931c853a539cc4c0f5251b185b0568add16d"
    sha256 cellar: :any,                 arm64_sequoia: "56d0960b96c6feee9b2057311ea4cef923892fa2a8c5498e0ca2f702fbe0fe78"
    sha256 cellar: :any,                 arm64_sonoma:  "56d0960b96c6feee9b2057311ea4cef923892fa2a8c5498e0ca2f702fbe0fe78"
    sha256 cellar: :any,                 sonoma:        "4627db8ab4081b2b8e25f1662a7da93893fc2ec3672b375432bbb18e166ce536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a1d8f2513cac42af4e113b11031164501e6f0be99372f0057c80b41f566a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94f9f838f7d126b1e1befeb8ef911bf4ea85e3c25fb7137968abf8db92dece73"
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
