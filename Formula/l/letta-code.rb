class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.16.tgz"
  sha256 "07e2d469039df6395569d5f2762a9621f142d86f71810092242753939510e017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70e9d7b733134980d4a4ace04cca55e0b0840adfe3b43eb1f9f20cf02d179467"
    sha256 cellar: :any,                 arm64_sequoia: "a8273882eb436f97fafa6e677842a0957258e3f3193f98c11aaeed687d22b9ed"
    sha256 cellar: :any,                 arm64_sonoma:  "a8273882eb436f97fafa6e677842a0957258e3f3193f98c11aaeed687d22b9ed"
    sha256 cellar: :any,                 sonoma:        "91fd327fc9c0ee01fe4efd7c6459a0b18cca3c5b356631b4447310d0c7255db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "036fd98095f9a6b3b8759fae30dd144c0f8a4e3f44944c43712a97f0ac64e3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507616278136e36a4e89c5fe3f88cde6699c5df2ad5c63e54736c38067437524"
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
