class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.69.0.tgz"
  sha256 "6fed51962efb57f751aa054037bfaaaaa379ecffcc517c4ce16c77e590035345"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40e0ae35ee3c002501e43a227c5c8b9fb27c13dd1aff2b196dc086dfc83b6c92"
    sha256 cellar: :any,                 arm64_sequoia: "e5536c8f2fb1e4a2864963369740bca6c64e8d43cdf6336df39db7e8b7b404f0"
    sha256 cellar: :any,                 arm64_sonoma:  "e5536c8f2fb1e4a2864963369740bca6c64e8d43cdf6336df39db7e8b7b404f0"
    sha256 cellar: :any,                 sonoma:        "90641b86f04b2f17d6283246b923085b4acac3e3bfd0c6a53c70fab3c1967a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90fc4caf20433dc837e9ad394be3bf6baad9a9af6679bff1df3afe989267a188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c780e38b03127023192931132c207036a510bfd7a215f26303455d7b190e277"
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
