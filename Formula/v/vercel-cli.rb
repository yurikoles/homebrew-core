class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.32.2.tgz"
  sha256 "fa75bf6afba2538dd941158dc7156e2f75e02849c45560d8e81f80e1a867d34b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b28457c239949ed8cffb5533fd98ff5be65a7a0ac55ae590c1bc5a95dbf9005"
    sha256 cellar: :any,                 arm64_sequoia: "b0e3a2ace1d499d34d212d0ebba224e606205f40cbee231c8525aec5010a1e1a"
    sha256 cellar: :any,                 arm64_sonoma:  "b0e3a2ace1d499d34d212d0ebba224e606205f40cbee231c8525aec5010a1e1a"
    sha256 cellar: :any,                 sonoma:        "5422045c4001755be9d56ba8b7a54318854c29fa1d7bb0ace80f4e1622d62a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2928484fe2102f9d43d520f1d213d96fdcfd06e1059438928c75744d3fb389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc3567a22ac03b98bbf38dd1fed644d3ea7badd7a84e7930f7f70d4e87c7fc6"
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
