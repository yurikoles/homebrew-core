class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.0.tgz"
  sha256 "9a4feb7d1643a6dca3ca62fab9c883d18d2838c1c717a000088d7a991fa3cc41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96aefc66b91e07fb29af634c1586cd7b7d086ef8b8064f3d45950cc30c65d90a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
