class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.3.tgz"
  sha256 "96b994fca63064e719e616a58ab6a90d69f036772b725f101e5a30b37dea997f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "851b0bfa54abcebdfffc45fdad36cbf981eddc444b12d76cb29b6f5fe3170a18"
    sha256 cellar: :any,                 arm64_sequoia: "e3978fd83298e38f3dc262fd09ef5240d183fd5a8fd77be6df997b85766d3804"
    sha256 cellar: :any,                 arm64_sonoma:  "e3978fd83298e38f3dc262fd09ef5240d183fd5a8fd77be6df997b85766d3804"
    sha256 cellar: :any,                 sonoma:        "8bc566089221207e08508b33493eed654a71d10f0b27775a474cda8b7f2a5487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283f4e0aa006c8315e3d6fe1505e66eedbe250c3f6ab6e4ba229f44a805a1ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465a9398fe09637b1e56f14549520817e0fd123fdaf5fe143cf41ddc157a282a"
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
