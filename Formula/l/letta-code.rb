class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.22.3.tgz"
  sha256 "79dc0ed61dcbc8e811ce42e4ab96e978bf25fd742bdb5f6114039967de5ca6a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a63d2a28d4490d5578b949ea22c5c0bd1153bc01d2e51438018d949622b4656c"
    sha256 cellar: :any,                 arm64_sequoia: "c0fb00e60b8ce161d4beee06d716f4a49d8e63b192ce8c7dc37dce6c6c32e3ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c0fb00e60b8ce161d4beee06d716f4a49d8e63b192ce8c7dc37dce6c6c32e3ad"
    sha256 cellar: :any,                 sonoma:        "5318724238a1d7c834537b0c8027ad3411e12767f86346b4e167dc4f530a8099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d875fa524a8d684fb8bf302278ef251884d5029c49878346d02aaed193e0845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2141c06a60b05035f6dfbe15d56fb2055e3fd8e37fc5340e3dd5e2a0c33d03"
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
