class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.2.tgz"
  sha256 "073999a906fb7067a6cf24d80138a7831a96cf4d032aa7a9854fc4134c5da214"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a547ac20d43ff210caed827416a3837093be2de77e053f63fd7a7be67239ce0"
    sha256 cellar: :any,                 arm64_sequoia: "592e3ce1aac8b7ff9fabe080cb173727f583642c1525b7a82cb650c1102bb6d5"
    sha256 cellar: :any,                 arm64_sonoma:  "592e3ce1aac8b7ff9fabe080cb173727f583642c1525b7a82cb650c1102bb6d5"
    sha256 cellar: :any,                 sonoma:        "001af879d8fa0bca9fdccf36ed7d737ca55e6569d600fca7786030e983e628e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c99cb4f286d94bb91dc47cad013c41a992bc54951104c473c043b76fe84312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3203aa70da12b320c91b646a95c7d908104172bd7e64024bc5021e194125cd83"
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
