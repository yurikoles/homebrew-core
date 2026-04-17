class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.5.0.tgz"
  sha256 "4b813eede0d6e26f315103f134d2670d5aee3d57d9b44a40f8877e46ebf226b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec3fb6d29411fa395760f3acc984e3f275b020f546c5900c6521204c6ec96d8c"
    sha256 cellar: :any,                 arm64_sequoia: "a09b3ba12ca44b0bde69907ab42efb3abe5078031db34fa07f67d064b268be0c"
    sha256 cellar: :any,                 arm64_sonoma:  "a09b3ba12ca44b0bde69907ab42efb3abe5078031db34fa07f67d064b268be0c"
    sha256 cellar: :any,                 sonoma:        "836342b00ec4726582a9c345e46baedae700261d8a17279331f57b61b906c57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c107eada9ffedba5e01a6175f17c6e1178cfa4524735d587dc029a3a4849b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a31e77609deed8647142bbdca708bad8cf399eede2d8e21d8f20a2eb394c6c9"
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
