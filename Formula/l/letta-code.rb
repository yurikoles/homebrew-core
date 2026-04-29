class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.8.tgz"
  sha256 "f2cdb40e688b87fc7d9567cf68e16868635d4ea886901ef8b3e3e5e1503d744e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39d72e0b6878ff7e79a169cf98a8a2afdf405685186fc0c61818a16eea10c69a"
    sha256 cellar: :any,                 arm64_sequoia: "f02549ff934061c7e529f6cc0d24b29f0a844dbc331ae82f9498464cfe505869"
    sha256 cellar: :any,                 arm64_sonoma:  "f02549ff934061c7e529f6cc0d24b29f0a844dbc331ae82f9498464cfe505869"
    sha256 cellar: :any,                 sonoma:        "c571fac72218697de5fa3fe3210c44b81ddf56e942fcbf5d6e83c2caaec800e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e427e5afc5c7cad930fbd35241ad24fee3e74fa20b42f0756a55508db77620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5560193b9961f6b8bee5256e69158323e16a59ba417fa8db575c992fb6adc769"
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
