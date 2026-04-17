class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.25.5.tgz"
  sha256 "12126bd9b6befdd422474e5fc85372326444f18de96dac12fb21d3acbb4a7b37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3838b789968e42727ca8fbbcd252a44a67e1834b433e103afa085ebeebf909a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3838b789968e42727ca8fbbcd252a44a67e1834b433e103afa085ebeebf909a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3838b789968e42727ca8fbbcd252a44a67e1834b433e103afa085ebeebf909a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b54127ed0eb408f3d60e7f1cb7819ec54e693ee34cf0d6e58dfc5c80b27c5d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "936ff523051d53da6180117de88783792963772ff48ee050b51ecfc861eb4af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfee141780bbc04f4be2e3a54ecd2d5d886fd43b70606fd28c26ab7ddec7bab9"
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
