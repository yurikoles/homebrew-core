class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.1.tgz"
  sha256 "5d13bc493a4113e93e9decbe072d78196a870147c26e7463ed4c47de24177c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "203f5ae9bf6925d7a52b80bdda89e4caccabf292ae49c35898e32dd0a427108c"
    sha256 cellar: :any,                 arm64_sequoia: "dda794c0f396bc64af44e213be267dd4d6b1feca555458ec8929b4333c32058c"
    sha256 cellar: :any,                 arm64_sonoma:  "dda794c0f396bc64af44e213be267dd4d6b1feca555458ec8929b4333c32058c"
    sha256 cellar: :any,                 sonoma:        "66512d634d1d23b02c6e5e9bed879ce58f108cdf3f93b3f6abd3c2b2864ccac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa84707ef3ae34529914981bcb319f8f0ce92792781d3bab50a22903c0967ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3e3a8cc736ce35bfce11fa68386c48319e0023360719953d0f99c48e4bd126"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
