class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.23.3.tgz"
  sha256 "66b963c3a4ca66338e89ec69f4fdfbb950bdbbd68e8ce8acf97b9271e8276e2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b10e0f5f8298848a9a7622cb66229a18c62c83ef124a0cbd180408b4e4fa72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b10e0f5f8298848a9a7622cb66229a18c62c83ef124a0cbd180408b4e4fa72b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b10e0f5f8298848a9a7622cb66229a18c62c83ef124a0cbd180408b4e4fa72b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c740352fc931dccd65b8f75a3856888283250e346a96d7fbc35c19904daeb1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc5a901f2b5410af3d5837d47ef50e81015373e32caafeae1a1951821099bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171bfd2e3b52de66b23c6d9aea18024114b80f0edc1af7e4e07773d65f2907d8"
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
