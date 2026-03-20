class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.5.tgz"
  sha256 "1aebca0400d160cb1bedca2e271daad0e324503b7e0d0b4b23781ca3293bacce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7267bd7d28ed7733aaeec66f07a1aeb5b80d4ca17214c6c7be412f4691cfce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
