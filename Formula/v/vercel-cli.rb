class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.7.1.tgz"
  sha256 "098a27d01d6acb50a2e5896ce2ff03c6c7c773befdfcb9ec9795ed96b04f9af3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6988ac6cc7f4e5155f43fd5cc361ac9ff319332b88d6fcd405fba51891322f9"
    sha256 cellar: :any,                 arm64_sequoia: "91a8a51ae82dfa2eef97aff4fcfb5c099b805678f66748974346f75581f842f4"
    sha256 cellar: :any,                 arm64_sonoma:  "91a8a51ae82dfa2eef97aff4fcfb5c099b805678f66748974346f75581f842f4"
    sha256 cellar: :any,                 sonoma:        "6e77a4d31609c8a271ff4d2629976dccef342da0ef62120b3b1d341b9e10067c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb2d2995ddc4af3939ea63ec604ace6e7b7ad73e8741e51baf15a04e67cdd656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a90847b76e7f11f70b3cb541a08e6af50717cee342eab89a687ba5f801b31faf"
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
