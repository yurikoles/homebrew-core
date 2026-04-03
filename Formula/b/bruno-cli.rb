class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.2.2.tgz"
  sha256 "6d97543c6f8b1d2c8652ce12b3cf878f40e3ac31f7c18d45be54f24c5c7d86e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3445a1396d2afa67b81586d351674881175bd6049a54a9888e2b4e3c17ae2d74"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
