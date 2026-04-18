class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.6.1.tgz"
  sha256 "48396f85668bac52229d69677e8de29ff3d4b46f300e78b62f41acd01e3b01cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fce3c091e2c4cc58d77aafff49eab5139e8198685ad6170147cca422cfdb44d"
    sha256 cellar: :any,                 arm64_sequoia: "550a9660525fa7f59dba30e0b9ac5a1153aa52c2ad471f3700b0a0bf9f141acb"
    sha256 cellar: :any,                 arm64_sonoma:  "550a9660525fa7f59dba30e0b9ac5a1153aa52c2ad471f3700b0a0bf9f141acb"
    sha256 cellar: :any,                 sonoma:        "c4740c30fdddc65f4badeb6b093653c020d18487af3e8383a5212b8171b4d033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28fe082dc6e113d7b8302d93f06b33b604501329dc1be63a9e24af4afd13838e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086a977bfbb08cee691de879ad76065816e03eb7f498f77cf0262a2a38f92fbd"
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
