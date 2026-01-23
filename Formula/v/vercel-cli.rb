class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.11.tgz"
  sha256 "711146194223a31bf37f467ee7c81a1d105ed9e82d120d4ac04b7509673f1bfe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0e35d877f62a2d4c63875ad01c2e13bcb39c356d1c6c71e7c6417e83af08cf1"
    sha256 cellar: :any,                 arm64_sequoia: "f5a3e842701bafe8cd661af0d2e416366aab64ae843cf5ae8ddab78ff2fbf379"
    sha256 cellar: :any,                 arm64_sonoma:  "f5a3e842701bafe8cd661af0d2e416366aab64ae843cf5ae8ddab78ff2fbf379"
    sha256 cellar: :any,                 sonoma:        "6c642773b18995b1d2ecaf266ac9b78fc02755cd0153360f4a9714ee44d5c3ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc64d3311e30222f8c5fab045b2f8728a455711aec1ba8c6042b4c5b488dcba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df3153b08912bee3804e059077567bc54abccd68bc86a84f0c7c7420facbb940"
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
