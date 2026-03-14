class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.58.1.tgz"
  sha256 "2ca6c7de9c2b7c4d1bced79b894abce02c35d4eaf5370fe3de55321b2d75ba0d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "232986aaae71b088258c3148533bed0fd3f2d0a8772f3c4b0be560ded8711265"
    sha256 cellar: :any,                 arm64_sequoia: "6f4fda634cb2237371a540d5b60672063f66191f7e18c06ec7020dcf42db4771"
    sha256 cellar: :any,                 arm64_sonoma:  "6f4fda634cb2237371a540d5b60672063f66191f7e18c06ec7020dcf42db4771"
    sha256 cellar: :any,                 sonoma:        "57f7ffc226eb99f9dc94ce04bfa6561dd990621df5c522ee46d00b6e83a32696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8612a299bf848767fe23d168d648e0f47d5ded9a0d1f23c8dd955237a6317763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bfa1303b705bc1407ef8eee2c001e5fda048dfa6c4f141440cd34731a78e9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
