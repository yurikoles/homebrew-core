class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.6.0.tgz"
  sha256 "782b143ffc24b679e503e3cb52757c279739c952d13524b2d9450eef7925db1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c23e6cfdfb1a31cbe9554b7bfafff7481e8086efcb2d210573a338a42aea4f1e"
    sha256 cellar: :any,                 arm64_sequoia: "b10f8b5a8f265f532f18216066ff4b35e5913761c218ce1753e13e7d10b64069"
    sha256 cellar: :any,                 arm64_sonoma:  "b10f8b5a8f265f532f18216066ff4b35e5913761c218ce1753e13e7d10b64069"
    sha256 cellar: :any,                 sonoma:        "babcd91d2d630783e36d431863ed9f4fe935e34bf2b824db473bb8413f57e42f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd5cea792c3cf2e8a417fb68587e562f3b67e5a44d83aeafe356cdeb9e6425d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd0acb1c92256311c85e8ef461086016803fbcf7417c3cbdc8b1d1da88537e2"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
