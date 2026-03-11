class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.31.1.tgz"
  sha256 "abf94e23758a600d6ff8dac3f7c35ab81089c2aa3e7278dab7faf3234f0ad81d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f5a4bc748d76a412b174884e18fe62b10658ec1cff9bc37569dc076d3932cae"
    sha256 cellar: :any,                 arm64_sequoia: "eeda8b28bc10337a023abf79ea5f29c57575581487bb5590c7640f21794670f1"
    sha256 cellar: :any,                 arm64_sonoma:  "eeda8b28bc10337a023abf79ea5f29c57575581487bb5590c7640f21794670f1"
    sha256 cellar: :any,                 sonoma:        "3fdc7c1ec3f87f8864d31d0c1cb8f212b92d3150fddfa9be1b4fb8af14690a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dd9efb30033ee27163c0a045a5c17affcf7740b5fb4def31118578f401260de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847a2a8c06a456d1c35e2b68f47d912c7b29c37c9f4af1a61418def8d6b4ce51"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
