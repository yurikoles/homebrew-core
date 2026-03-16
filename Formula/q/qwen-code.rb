class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.5.tgz"
  sha256 "0af9f0f6e27a23d6d39da545ce6725a9d9a8250a6524c12768f8995b6506899e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c178932ede616c6b4a4b68579c49773e5b302599fc9282480186cf741efeefb8"
    sha256 cellar: :any,                 arm64_sequoia: "8f6bea237ba1fc5fee3894dec51f41a7d102bcda412ca6b6c66e6b47dc2d4a66"
    sha256 cellar: :any,                 arm64_sonoma:  "8f6bea237ba1fc5fee3894dec51f41a7d102bcda412ca6b6c66e6b47dc2d4a66"
    sha256 cellar: :any,                 sonoma:        "0e163bf7904310cf5c8da5e594524fe373a96406602764d576c9b4f3796199fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1392a4e715d80a6c23a0a779d8d8ded81542466b27a218870a3d0640ed35519b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef114474a0df2b167f6a8b4c28f7215a46b9486318d3f49a07974c45e5173808"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
