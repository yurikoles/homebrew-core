class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.8.1.tgz"
  sha256 "49bb2444a7b6e0a01047f50b68066321ef8e67cf7308a4fcb61556b39545c6ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd079af903a909859870d6c7815adf5dc6252f9dbc29385142178dc06bc6e2e7"
    sha256 cellar: :any,                 arm64_sequoia: "f9a139b068dc5a112fd1c9212dc74c4166da39127d33e6becd3eaa73bdcb868e"
    sha256 cellar: :any,                 arm64_sonoma:  "f9a139b068dc5a112fd1c9212dc74c4166da39127d33e6becd3eaa73bdcb868e"
    sha256 cellar: :any,                 sonoma:        "91076d0229241de7d8eb0fa4531bed0493140464538adb38ff64da0d3c227c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc0a1a53e3432605a82b7f3c0f9fbf19c68fe3382fa272cea544104dd2bc57d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d424dc5be4b544f4540b356963063749767aa38e8ab4a18025e5a0944086e29d"
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
