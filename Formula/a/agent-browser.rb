class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.8.tgz"
  sha256 "3a17b93fc2758631a8900f70a8dc2886164c09324336d6417df0164634c18ea6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef0890f8ee6242d4e7b5a7d9ca5177a59fda166d66c2ad5f4b8fa7e54537b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0890f8ee6242d4e7b5a7d9ca5177a59fda166d66c2ad5f4b8fa7e54537b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0890f8ee6242d4e7b5a7d9ca5177a59fda166d66c2ad5f4b8fa7e54537b8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e3f764d6871fd12efb465899addf3c90c19dba77ab9af3f69ae7b033c9891e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169d996177d8f635c66d46cd97b3243e22c08eaa96a2e486dc39b6bb92b90631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f25d92d72b96fcb88360954d1e7d754841118c6b389c26edff80de69d4d0635"
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
