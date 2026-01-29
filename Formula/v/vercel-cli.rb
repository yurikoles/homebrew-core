class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.2.tgz"
  sha256 "52a783a33c07599c7036af6b307d25ea772e852bf7c53251974ab870860fa84e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19929f208d9bb78f324163cc3c242dacf5c7f15a322591272936320e487b240a"
    sha256 cellar: :any,                 arm64_sequoia: "2df792c28f11d0005879e0db192c1ed7dad32a8eca7d336a5ae36c63452aefaa"
    sha256 cellar: :any,                 arm64_sonoma:  "2df792c28f11d0005879e0db192c1ed7dad32a8eca7d336a5ae36c63452aefaa"
    sha256 cellar: :any,                 sonoma:        "fbc5b8ea740988334a9c66eb5c0100b8d10fb898c26c52464b1ca5b1a91d6d0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e80fa754f5fcc4ac012418f0836545786cc40f85177b754852657b62c4be971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5890872a316889834fc030e5df432ca1595e74fa5c0cf9ab06d836a0e9347893"
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
