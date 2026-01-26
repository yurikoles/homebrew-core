class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.5.1.tgz"
  sha256 "575e26aba6bd37c0c79759c59d0f3feaeaee0ee06a4d9656baf0fb17b686ad8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8521f995248dd11810b9f58f54e45457fbac0eebf60a9373c1d44f09f246e894"
    sha256 cellar: :any,                 arm64_sequoia: "a84c97f51dc2e38b2771f064c5f2109d86431f8ac3a45eb35fe56965ac60619a"
    sha256 cellar: :any,                 arm64_sonoma:  "a84c97f51dc2e38b2771f064c5f2109d86431f8ac3a45eb35fe56965ac60619a"
    sha256 cellar: :any,                 sonoma:        "00aa62c0df7a11327d2374b62c11fc787f7c4b0fd43f33014fc23ba7bd6640ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb45f35f5e3922cde381962918c64247e98bf8f328a5f275b4934e554752ae5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c03cf792dd5c8607cb098987c3de7702f93e3796389321d406d5b2951403049"
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
