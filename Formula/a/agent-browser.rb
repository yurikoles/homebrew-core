class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.22.2.tgz"
  sha256 "bbdf08a19bdf817055d119b41e0b6e79096c632d3638fc79972f7668f71bb391"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf2f1c7f65b563e08511a9d0da552250e8abb05c9d1a89d5b4e4907e1402adf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2f1c7f65b563e08511a9d0da552250e8abb05c9d1a89d5b4e4907e1402adf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf2f1c7f65b563e08511a9d0da552250e8abb05c9d1a89d5b4e4907e1402adf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "62557f4bc88d463bf994c71aed0d95b15e59c48068898dbecb48066f6c4a43e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ce87282197b218f94b3732c4dc94ab670ae0088dbd3840352d63afc4a863a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6a2945af6fb12ce90129f6d7b88941a6f2354e5d176f062ee3be1d407907e8"
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
