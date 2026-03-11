class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.31.0.tgz"
  sha256 "fe9dbac4415b75c6cea6e293e80a6a536fb85a467e321cb0db208038356633cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d52d2b83c8b7a935e40e33cdac596776210956da0ba0c7519945dec502e53b66"
    sha256 cellar: :any,                 arm64_sequoia: "098f125cf8608efc51fcd017693e3df1d21bc887470c63c8b7a8b8f5a784cfbe"
    sha256 cellar: :any,                 arm64_sonoma:  "098f125cf8608efc51fcd017693e3df1d21bc887470c63c8b7a8b8f5a784cfbe"
    sha256 cellar: :any,                 sonoma:        "d9e64aafd16278f92d18b83ec7613d6f0aa32c3ef1436b6f39f4dce67f845ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c59cac5277e0b48ebf0444c7ce0985156c2e0450019235ab3a78ef9d93def492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28dcc846344577cb4ec29112ad890c0ae6046b0031a5a93e6c4169005362b3d9"
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
