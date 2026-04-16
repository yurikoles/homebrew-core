class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.3.0.tgz"
  sha256 "9740bcf5b5158b42c839ca1ddc63d1f9f28b0f44c27589be14960ec6e30aab90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12fd6a75174356672f52abb1bf5579d4ffc9897b7f265a4e5396e2d51db8dc1b"
    sha256 cellar: :any,                 arm64_sequoia: "59eda93018129075db6bacd695d239bfc6a113d07d1caebde5cf072dbf83d675"
    sha256 cellar: :any,                 arm64_sonoma:  "59eda93018129075db6bacd695d239bfc6a113d07d1caebde5cf072dbf83d675"
    sha256 cellar: :any,                 sonoma:        "8c97b1734d13b61d7ad45f4f601ae1e4060ccd765a297cff9943186dd0b54665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5377382abffffbb377c967bc1791ca5e52776ed8f44906e70cec1a2a33a5c6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9e532b35ae1637271e50c03d1591acf5c13abdc24fc894c3cd84e68c60ad7a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
