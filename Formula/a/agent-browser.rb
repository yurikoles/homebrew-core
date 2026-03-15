class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.11.tgz"
  sha256 "6190ce16330e45e9f0bacdae20349ea3d5efb5dd8b5e7308ed0e0dcfe8e1001f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2992ad36db54816b0a0d88eb767441e8141a765ed9db9319edc0f3dfe3f8cd04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2992ad36db54816b0a0d88eb767441e8141a765ed9db9319edc0f3dfe3f8cd04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2992ad36db54816b0a0d88eb767441e8141a765ed9db9319edc0f3dfe3f8cd04"
    sha256 cellar: :any_skip_relocation, sonoma:        "03676b40d6dda2daa0ab861afd23f2b28eccf84840fdfa3a9c209f4081e7d4e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d724b885962f7b71e70956f25f961ecbc76dc85cb59961253f8bbcb8d21590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a478bae224b5cd2daeafa5993bcaa25984dc3d96f714b3be07131c9857f10cd"
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
