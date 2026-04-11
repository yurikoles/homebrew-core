class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.22.1.tgz"
  sha256 "8bc1fa41d3080d967312d2fb32388d860519b7887c6c5f681bd0ebb490d78122"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "679cb034b6530ff991d8aec04ca506703bf3b7825d37ece5eef7de9c31cb9e15"
    sha256 cellar: :any,                 arm64_sequoia: "32e04ab33e88b8b89388366c13d23a444dae1d2c6072d73f36207bfd70a7281c"
    sha256 cellar: :any,                 arm64_sonoma:  "32e04ab33e88b8b89388366c13d23a444dae1d2c6072d73f36207bfd70a7281c"
    sha256 cellar: :any,                 sonoma:        "e157faf5f03e23e855e5461774d74e7992c65663661883561db2c16dfc68bb6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaad1852eb190ede000c1ffd1ecbc8b671e48069dd3fb7b8a40ca9bd8d9cb355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1207e12c14dc32e034701bc1079f93e7e83a90a27329611bac9a1e90509a9b14"
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
