class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.38.2.tgz"
  sha256 "f1f717709d72dbb64cbfc1374fa0aa8328fe9bb7e388c69bfab794c976427cdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11afc1ced554bc65081786a546e627004a0f25397fb7b6c54c58266be4e48b18"
    sha256 cellar: :any,                 arm64_sequoia: "fb640595270dc68456e392af7209dccc38a9ae3f23b941a6e2f00d68db2d2351"
    sha256 cellar: :any,                 arm64_sonoma:  "fb640595270dc68456e392af7209dccc38a9ae3f23b941a6e2f00d68db2d2351"
    sha256 cellar: :any,                 sonoma:        "0c3ffa00f17c204c9314a48b31851d006ea078e37308f6dc9f7fcaca5c963716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09a27b9c049ff06059ff47ea59d582317bb25caa0c9a7a37d6325dc0741c659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8876511483fc9e2a1a244088dfb1a28b2271c278e69a9741624c5482bd469db5"
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
