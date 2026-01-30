class ClawdbotCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://clawd.bot"
  url "https://registry.npmjs.org/clawdbot/-/clawdbot-2026.1.24-3.tgz"
  sha256 "a00acd33ac20787fbd342db2bc36db15b2483f88e1f8b159cf1bc37a6eb1a828"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "964654ede929bd797bfc15abf18f61edf9f1f8e2797e44ef325b96ad9e596328"
    sha256 cellar: :any,                 arm64_sequoia: "e169d530d1bc6b06aadaf098b69887a324c9d96b692180678b4ca9cfad310be2"
    sha256 cellar: :any,                 arm64_sonoma:  "e169d530d1bc6b06aadaf098b69887a324c9d96b692180678b4ca9cfad310be2"
    sha256 cellar: :any,                 sonoma:        "adc792231b8f6081921baab3fda783255df3fb3e903aafbc627b49ec0abe9d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c4957a45ba074ff7d5f35d3028a892dfa7609670c10c97b617eba83ebc752e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9cd2101133e4f8508ba92a3a82da3510aa132c2ab7a84daa7e2183cc6954bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/clawdbot/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    native_prefix = if OS.mac?
      Hardware::CPU.arm? ? "mac-arm64" : "mac-x64"
    elsif OS.linux?
      Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
    end
    if native_prefix
      node_modules.glob("@node-llama-cpp/*").each do |dir|
        basename = dir.basename.to_s
        next if basename.start_with?(native_prefix) &&
                basename.exclude?("cuda") &&
                basename.exclude?("vulkan")

        rm_r(dir)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawdbot --version")

    output = shell_output("#{bin}/clawdbot status")
    assert_match "Clawdbot status", output
  end
end
