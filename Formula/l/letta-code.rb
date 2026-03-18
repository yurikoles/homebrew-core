class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.2.tgz"
  sha256 "28ebfc5ceb2774fcb250a9d9f9cdd63048b3154dabf3f9c00760d114a2bb8b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7dc0c89f4cb9bdac0632280a42d36bcb0f13a1465aab9d9ff76076ebdd99b97"
    sha256 cellar: :any,                 arm64_sequoia: "133a357061a746d030d332fc7511f777a81a2a11f34e545f800228829c0417ea"
    sha256 cellar: :any,                 arm64_sonoma:  "133a357061a746d030d332fc7511f777a81a2a11f34e545f800228829c0417ea"
    sha256 cellar: :any,                 sonoma:        "3c026e9b6e978f301f9a358114f12df9ca62fefe909c76783c2d5870d18e601a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278a44e6bb13fe3e3687e708e0b96236d457ee3d877277ccf8b1ba49c8f46667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0af3355f70d6beb9056c00a19eababf8a945cd861bef57c2e6d2190222ecb43"
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
