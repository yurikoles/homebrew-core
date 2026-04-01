class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.6.tgz"
  sha256 "bd309b48d87f79008c4277fd4d1f618e336d8503442f5524e02656ea20a87db2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c73346ad669949a156ace635a1f8aafa0a9035f1c97c821ad8c347fbd692d231"
    sha256 cellar: :any,                 arm64_sequoia: "3ad3e876c5888fd5e07c16d10fec28e184e2bcb906ba92f5d89852128f73b89d"
    sha256 cellar: :any,                 arm64_sonoma:  "3ad3e876c5888fd5e07c16d10fec28e184e2bcb906ba92f5d89852128f73b89d"
    sha256 cellar: :any,                 sonoma:        "2e19fde4eadbf03d61e6ad178216304cbb030b63a61b50c3f633e92f66feed87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c326e8f08b911e8f121e34b46ef206aaf0c3f21bb88e96a8d4e0770b456f8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3553a4d2f3f9492ce4185e44de6bec9b9dfa3167ef38421bac66968d630dff1"
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
