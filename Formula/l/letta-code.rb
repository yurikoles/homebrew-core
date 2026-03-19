class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.4.tgz"
  sha256 "0c33202b4ed05032c5e9f2d8f9721fce4084891626ad343a949343d02f5896db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e67559e753533c3afe6e6842c87caaa8047279ab5e479add97bc9dd5e4a3f2a5"
    sha256 cellar: :any,                 arm64_sequoia: "42d864591edd732127c08aca56b9f5109644309eab5e0810c7820543ff7ac0bd"
    sha256 cellar: :any,                 arm64_sonoma:  "42d864591edd732127c08aca56b9f5109644309eab5e0810c7820543ff7ac0bd"
    sha256 cellar: :any,                 sonoma:        "a8d9398c4c2f01e6acf11cc6d88df5aa9f5ef537e14ecf1fa9ef2bc383698dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d8c2d35ba1809f25a033ef458b70da5207f412994ccc656765e2e0d43df2ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1a0c7709f9edbc88aa2ee861f2cc0eeb0ac18345e1df420c659d86db106b7d"
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
