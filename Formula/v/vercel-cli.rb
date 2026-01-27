class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.7.0.tgz"
  sha256 "b5b9a55fc081f28c13b2a23ed0a1a23fc46f6e38ca34e9b156555eeb0e08fa8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b5c7c5f8c458b46cd35d8b6e4ece1d7749bb3e9dd545a5bcf1957446a0ede29"
    sha256 cellar: :any,                 arm64_sequoia: "3227791912a04a6f87b06f352f63a525d487564709b6debfc9462d2d84e83299"
    sha256 cellar: :any,                 arm64_sonoma:  "3227791912a04a6f87b06f352f63a525d487564709b6debfc9462d2d84e83299"
    sha256 cellar: :any,                 sonoma:        "e58a7b4f94f7422567cfa026104a9234af349ad35aab69f87924cb610c96dd4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420cff89bf3fb30959d756df93d3503c4944f01197b8df833fcb654e5c95d23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0d3c7c0d2adb2f388cfc300b574aee74853df9ec65721057285309c925ba9d"
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
