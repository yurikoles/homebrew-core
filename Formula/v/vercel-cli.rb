class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.1.0.tgz"
  sha256 "90a69a2b6700e7dcbe314fa6d69c68c3711c050ce978b9ecaee3509df7525433"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2836f8b4c80c8e193974506ddcbb57c00025064bfe67ce740ebb0e48196d1c7"
    sha256 cellar: :any,                 arm64_sequoia: "41fade17a330e17d6652bbb981e5aca73caa3cefd974e6928ec8b531262643a5"
    sha256 cellar: :any,                 arm64_sonoma:  "41fade17a330e17d6652bbb981e5aca73caa3cefd974e6928ec8b531262643a5"
    sha256 cellar: :any,                 sonoma:        "d92a805a154a50462f43d0af4459594fa8eb4b6ed5c0a58cd1935d6e6e08d0fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2793e9a8ffbaf915f15501308b20cfdbc94c08e2cea668d579469a4ecbd6081a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7271084a856ccd4b7df8b8ecf302e4f14f8907ce92b9dbe4f56b01274fef4015"
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
