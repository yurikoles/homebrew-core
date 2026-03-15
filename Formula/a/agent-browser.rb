class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.8.tgz"
  sha256 "3a17b93fc2758631a8900f70a8dc2886164c09324336d6417df0164634c18ea6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57c4c9926a14238f86e2ab8b9d754a45c287dda939d70cb615e0beee24078ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a57c4c9926a14238f86e2ab8b9d754a45c287dda939d70cb615e0beee24078ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57c4c9926a14238f86e2ab8b9d754a45c287dda939d70cb615e0beee24078ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "7641a43d427ce04d062192a9983455263397f1e433a0144847609d5baed74ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4602ff8af35e0cfc47551676aaffcd8190ffc723a4cfe2f313b6b10c239ed2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb86c127b928321d5a64064f9f2eef4111abf066f1ab502f9401589b106bd82a"
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
