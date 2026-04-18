class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.26.0.tgz"
  sha256 "8a48cf4110d7dc2c12c1c4d6d25e0babdfa31604b537f05df0dc835fe2f854bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd15b236870fa458542435a7a712fb7b1e90afa9064719fa2a1c2bd36441ddab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd15b236870fa458542435a7a712fb7b1e90afa9064719fa2a1c2bd36441ddab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd15b236870fa458542435a7a712fb7b1e90afa9064719fa2a1c2bd36441ddab"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b6012df291fd045a9a96885cc446a2388b44e7b89503222ef625ae56f92bdba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f5e6132b7f25b7728b78047a2c9033656a4c103c40369da678dff2eb2c36ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820a94ef1032d2717f9c34145c3e71dc06eb30c0771b8d6ef49525d283286300"
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
