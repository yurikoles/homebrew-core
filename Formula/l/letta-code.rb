class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.9.tgz"
  sha256 "ab457019390bf0b775edf3b4480160b2328aaecc46590600f174faf8a2e36dfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44bcff958ce046e0c2eb3f34e8c09e963e5d09b4461178ec0c1e71fcb5f3c661"
    sha256 cellar: :any,                 arm64_sequoia: "b6faf48cd7f5f9e2941ed745faf8669c4708a4c5f6d034f94cbd56310fbf7c3d"
    sha256 cellar: :any,                 arm64_sonoma:  "b6faf48cd7f5f9e2941ed745faf8669c4708a4c5f6d034f94cbd56310fbf7c3d"
    sha256 cellar: :any,                 sonoma:        "ddf0c8529b526968b62a53332cddf0a28c218a3e3a9743edf7c95a334313a29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96404dcce9dc87647d46d96994bc80ee0c8634fa4b5072b8664ac54cd6c70a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a077d2ab9616b169a2050dafb869bfa39fa9f33dc80a16cc9f69d3f25ad924e"
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
