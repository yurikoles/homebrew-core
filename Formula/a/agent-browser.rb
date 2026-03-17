class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.0.tgz"
  sha256 "a4bf26cd9c3708abcdbe72fe414f9fd30eedf287ae2a98fa0f1d3a8b4b59cfda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f385054d2ef8d5190b918f8c6fa725f988d4b87d93a6bbd74ccfb314d41c7e3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f385054d2ef8d5190b918f8c6fa725f988d4b87d93a6bbd74ccfb314d41c7e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f385054d2ef8d5190b918f8c6fa725f988d4b87d93a6bbd74ccfb314d41c7e3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3f49265eafbbd0e0d1788f643e901d8d6fec040da5253ba606e07754f612d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2872a4e015d3e7c12a4b9b0e363d9a92e3a13a54362de2d5f2fc13eb75cd52a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa6898ce762d0d61a09c291ef581f70818e56361fe8af6679a6e4bded0a8dab"
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
