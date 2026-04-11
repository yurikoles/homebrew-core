class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.22.2.tgz"
  sha256 "8756650a960ce841f551d9cae715b39e7dc3175a970ec8901c30f9e91bf605ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55ef8bbeea5ecd8cb33191352b9fac4b652c98af633461112ee722950289dbfd"
    sha256 cellar: :any,                 arm64_sequoia: "8186919894a116df2d05b478126f550f57f75f1a57573df0779dd233e3aa5a44"
    sha256 cellar: :any,                 arm64_sonoma:  "8186919894a116df2d05b478126f550f57f75f1a57573df0779dd233e3aa5a44"
    sha256 cellar: :any,                 sonoma:        "6d80200f4aca72fb37cd6d0f3408d104b6e04e55a9e2e35caa4fbce0ab99fd8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fcda01818b84fcb7ddd6f08145bad508a802fc24724e64f3b1ac5ca358751cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78175cfed83e48cdb4480da5f9a933fe4bf6919c204ad99841894b8abe99717f"
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
