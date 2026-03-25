class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.9.tgz"
  sha256 "1fbb8c6b899c20948e4cfea8b28c268423247a4159ba5538384ba67cf9e5c1a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d12ff8ad62272efa570a395582b5b075eeddb34bf65b42e4ba371594d3bc1ee"
    sha256 cellar: :any,                 arm64_sequoia: "85e004be7bc31bd62969919a3988f4f60c6bc10763904e6cc1c33baa2a463c95"
    sha256 cellar: :any,                 arm64_sonoma:  "85e004be7bc31bd62969919a3988f4f60c6bc10763904e6cc1c33baa2a463c95"
    sha256 cellar: :any,                 sonoma:        "b9cee13f6480bf1674e4b613f06d25fb677dff9ff7a0a4b57133a7882a75b44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebe74794015880b140b5e0d75e8a5bcccffc89cff9d6493bd57f552d0e98b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6185f579d3bd18d48cd8d74c9460b457017c8ad4f23c9a2bca209576781de1"
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
