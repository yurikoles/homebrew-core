class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.64.0.tgz"
  sha256 "492748ca1a0af4311ad2a14d2b7740b133dc3a1be1250ff0ee4955081da4a99a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e0db9b7348aeed8a54a972696ca868a32e4b36197c53f7e35a872ec983b4aca"
    sha256 cellar: :any,                 arm64_sequoia: "c578a1405bde4c26b554f5f9a7952ed2132ea152eb786131bddab1ee6aa1f9f6"
    sha256 cellar: :any,                 arm64_sonoma:  "c578a1405bde4c26b554f5f9a7952ed2132ea152eb786131bddab1ee6aa1f9f6"
    sha256 cellar: :any,                 sonoma:        "c38e1d8beb816d2996ad5e0b0b83c244799078da76ad115b0abd834b7a07af58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e38f05b669c3ec68f1e2829e87a4f8ef065c4c74f43c039276d148ff1ae5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afb373ca965302f302701f2c1bc22244649ad6e646e41bf1a25aeef112ff4c4"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
