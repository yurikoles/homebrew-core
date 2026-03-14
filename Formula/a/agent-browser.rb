class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.2.tgz"
  sha256 "a1b21bc812f73a0cfab949cacdef48ed5d89fd94e33e5d87c086814e92c98476"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b08d5fa12cb646e59895fab78fd0e851694ac59f64b8764da06b79a5b316196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b08d5fa12cb646e59895fab78fd0e851694ac59f64b8764da06b79a5b316196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b08d5fa12cb646e59895fab78fd0e851694ac59f64b8764da06b79a5b316196"
    sha256 cellar: :any_skip_relocation, sonoma:        "28659d652f06115d70e51bf425bbcda98e2d3a25082495070c03f48ee1c7b39d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8937f1900a282441af1816896ec3beaff5e78cad2a5a6333f9e6501efb179c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45877d41c664ce5b0d2a8e6a3ff3ae43e84e734dbcc586263f58a5868a921ff8"
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
