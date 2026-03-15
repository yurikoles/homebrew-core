class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.7.tgz"
  sha256 "442d2cc8963fae931dae8aaf0b4739ccd84d7d48596e33f5be0f372ed791f428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28bbc73cb0c89365926e853e203ba800f9affa47a9332e6005e97e8c6e06de3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28bbc73cb0c89365926e853e203ba800f9affa47a9332e6005e97e8c6e06de3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28bbc73cb0c89365926e853e203ba800f9affa47a9332e6005e97e8c6e06de3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc9e794b1f2502b95cb3b3dea9c80de59ce1819de9e5b97cdb6e151e69ec0ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4417fd1365e3e01b02bb7a256b7aafe31783f18adec020a8062321235af3183a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce11ca6ef4b6e93394f96171eebd142bad55ed0b1cdd1b1a77fc0abb0bfe6d9"
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
