class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.5.4.tgz"
  sha256 "dc1c18f649b9d2372c19aba68e2080a666510c1cf4b4fec0b683f7ce68518bb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6173696418597634e22270a41f6a65ecdc7cabd73ecc5772f7662803e3ea9021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed001bf65d043b4b7ce98a463aefdb5aa0c7533053bed5d0dc321118136b43b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed001bf65d043b4b7ce98a463aefdb5aa0c7533053bed5d0dc321118136b43b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3472e3ef0f1c4f6fd2c299ce87595412aaa3d29a1dee6644686479267ae8e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a32482030386bd1bfaa4219087d88f729a8bd4d9d67756b4b2d06a9404399417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32482030386bd1bfaa4219087d88f729a8bd4d9d67756b4b2d06a9404399417"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
