class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.8.tgz"
  sha256 "016cea4a206bca4cb90d2c5624ff8c615852ba90eb6fc081148925042bb77046"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2e1f312dbf6f136c1cf643b3207efa0da86b56af8999621cbfe5f0d86f17474"
    sha256 cellar: :any,                 arm64_sequoia: "acbe729d3000df218778b42d0e412052e4ee61bb543e213e2460a2f7bd3e86ee"
    sha256 cellar: :any,                 arm64_sonoma:  "acbe729d3000df218778b42d0e412052e4ee61bb543e213e2460a2f7bd3e86ee"
    sha256 cellar: :any,                 sonoma:        "39c5820260a6305a4fa62eb996884c6db54edf6488f89e1e253f2ec14809f21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5157fc26b83c336a1fa8f0b1efffbb55c98110ad473dea9352d735eca5b4e369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a63df608e4ffc46494d401542b5408e37f9efb23cb5724c735350a733381d505"
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
