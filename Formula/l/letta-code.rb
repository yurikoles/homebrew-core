class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.5.tgz"
  sha256 "629f22ac3b97e27c9052871e839ef53477d0a47a205b8592c31b1cafb1f0f42b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bcb777743af61ebfaa3e372b934f5bbbea4a1325a4e204898d328f73637df7d"
    sha256 cellar: :any,                 arm64_sequoia: "28a9bcd8a672e763c78af2071003fae01f926e29d4740502531306e187980e64"
    sha256 cellar: :any,                 arm64_sonoma:  "28a9bcd8a672e763c78af2071003fae01f926e29d4740502531306e187980e64"
    sha256 cellar: :any,                 sonoma:        "d067aea410d98a989d89cddbe1823b749a91a7d3c35783bb20b4b5390326783f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a713b8885f5ddee2f352849c9d9b8dbfd0421139f21358f295ada7333d49e472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bfdc0a0990e21ccb69b4170d455138875983af3b714541486036ddeaf9d32ca"
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
