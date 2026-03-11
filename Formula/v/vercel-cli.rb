class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.32.1.tgz"
  sha256 "b78de01cf228a88b1191969a4c4037c9351246d4df94b224ff8f4fde853aa148"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63b0bc2402b11d4f536a7ade6fcb40fc43bd7e893c870cdf3fc0245dcca61fac"
    sha256 cellar: :any,                 arm64_sequoia: "25f9ef3e1016d6229df79ffcb147555186a3f94ffc75fc5631e906bd42fca81f"
    sha256 cellar: :any,                 arm64_sonoma:  "25f9ef3e1016d6229df79ffcb147555186a3f94ffc75fc5631e906bd42fca81f"
    sha256 cellar: :any,                 sonoma:        "1811552ac98bc538875916c5b6a59a814230924efc86786a61ded5c050a1e638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4df7aacd5f4c000e9a73741305d3ec766e8bd89cb22522ffbcca013f0d9307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4c34a0ed47de788beb8b6f6b54ba1e01a4b566619fae17723a0d5f1731b7ce"
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
