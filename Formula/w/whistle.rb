class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.109.tgz"
  sha256 "7baab6553e39d53440b8a2e7831696c3fc30831f6b8bb84807f783793f3e157b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e46c1fb5e0dcbabdc87936cb86cd1abd6c45b780f8f97272cc2da53ef7b6bfd4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
