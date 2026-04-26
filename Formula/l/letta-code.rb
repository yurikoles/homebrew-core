class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.4.tgz"
  sha256 "74e71e598f73d87bc544b55ecf60542086daa8dd4f943b32a7eb2bba90053691"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6db35a57beddca2aec2fe16b829b7eb33506773cbbbd3aee187ee6a2dbeada66"
    sha256 cellar: :any,                 arm64_sequoia: "e6519c665ca0000d3d28f9dc2ddfee3b6d1936b750c74d24e47fdad2f7487015"
    sha256 cellar: :any,                 arm64_sonoma:  "e6519c665ca0000d3d28f9dc2ddfee3b6d1936b750c74d24e47fdad2f7487015"
    sha256 cellar: :any,                 sonoma:        "b3e741a06d1da472400ab04771d760594aec795c247af3aba5e0d5979fea41e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aebea5168d6126d1a1cdad31491a5b00379b705eb3227c236b414ce79833e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80281275b182c5ca610642c35a6cc4bd7ac68552970e775074602dcc6f7326f"
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
