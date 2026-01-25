class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https://emacs-eask.github.io/"
  url "https://registry.npmjs.org/@emacs-eask/cli/-/cli-0.12.4.tgz"
  sha256 "80910c2cec6af14e102ff19ee0d05991d11cf8ad4394de5ad8444f2f201e048b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84fdf75b215e408e29bb1d41ca7855a55198e52179887eafaf21ce5868613b00"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eask --version")

    system bin/"eask", "create", "package", "test-project"
    assert_path_exists testpath/"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}/eask compile 2>&1")
  end
end
