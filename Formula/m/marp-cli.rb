class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.3.0.tgz"
  sha256 "6ed46d251e50670c8bc9b2d9b937c8dfd7c9865a4d5c5e2eac00643f9a68d77e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa13b22059ce6b8755595dfdfad7db308f3a89d79892d38c7fb315843ab531f8"
    sha256 cellar: :any,                 arm64_sequoia: "f171d94b6328184555c5b68a73317afce2ed7572b04ae62dd9186cbaf2954b20"
    sha256 cellar: :any,                 arm64_sonoma:  "f171d94b6328184555c5b68a73317afce2ed7572b04ae62dd9186cbaf2954b20"
    sha256 cellar: :any,                 sonoma:        "32d27d395804c63b210ad408352f19471c3bb2ca25db5372c95cbd7482c0d93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd878c09b09f0f7d2a6d9e579076f8c163d51ffddc8197933bbcb221a882fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821db6be0855e372344cf2ea64e8ca836600aadef798cce2d4d98583f303502e"
  end

  # Remove when Node 25 is fixed upstream: https://github.com/nodejs/node/issues/61971
  # Formula-specific tracking: https://github.com/marp-team/marp-cli/issues/708
  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"deck.md").write <<~MARKDOWN
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    MARKDOWN

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_path_exists testpath/"deck.html"
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
