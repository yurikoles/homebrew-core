class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.1.tgz"
  sha256 "5d13bc493a4113e93e9decbe072d78196a870147c26e7463ed4c47de24177c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "666cfe39dcff13ad902dc4ddd882481d65d372a827570365fe39386cbd5fad81"
    sha256 cellar: :any,                 arm64_sequoia: "2641ad5a9fa0d84f5aa44ad5b15b98b44ffa3ce4db77135bb1bf947aaba9bdc8"
    sha256 cellar: :any,                 arm64_sonoma:  "2641ad5a9fa0d84f5aa44ad5b15b98b44ffa3ce4db77135bb1bf947aaba9bdc8"
    sha256 cellar: :any,                 sonoma:        "36b4a2720b2b59d07470ad9282c78f593a1087c04d27b24e755533f8fa446866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a671913326133f8bd22a27c632b680ebd79e7de7b9a74b87724e8fd3c8d4e29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c9922c7362cdfc25e5a548e290d1bc1daf64cf73d1d83e3f6066464060ad6c"
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
