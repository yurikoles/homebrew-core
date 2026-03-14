class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.4.tgz"
  sha256 "cf2d4563016d2d184ee27fdb66a1a5023545c988589e9344b15829e76adad2bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e056b5618fe3b3564690a2285aede5d8ecd5291e8cd1fbf10f7e89f6e3cdf8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e056b5618fe3b3564690a2285aede5d8ecd5291e8cd1fbf10f7e89f6e3cdf8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e056b5618fe3b3564690a2285aede5d8ecd5291e8cd1fbf10f7e89f6e3cdf8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f9180662ef2819c7b5c33655169b5731331558caa9df99df0d9e90c668665a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6de754cec859d4a0cd21b78a0a59e87e1e5a91c70eaa7e23aedf16da3c719be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd65ec426787b59e02526335e4b719042b3b3d7834314c4dabdd09c88203e46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
