class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.3.tgz"
  sha256 "58bff30dc877da34be5e53b04dbe61bef8f94347f87d7a8aad8a473421560910"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ef0da85466b5260a1ab43ed718fcbd9a2892053f70ec19ae8b1e6bce0dfe208"
    sha256 cellar: :any,                 arm64_sequoia: "6a0922467e67ccfdd598d0a13dfa22df97ac43b10aac5333bf827e2c474ceae2"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0922467e67ccfdd598d0a13dfa22df97ac43b10aac5333bf827e2c474ceae2"
    sha256 cellar: :any,                 sonoma:        "7249d98ea3c241bb97b327b73ce4088c1b3dbcc628e45ac9e4bfd76aa6e746d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba790119a35a7018b4b20bd0c9ab736cf3730c25a3243aba373bc1a2db59b09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e162da324447f729d7ad626139ae440ebfcee9d2b47fe427a8aae7a5b439a50"
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
