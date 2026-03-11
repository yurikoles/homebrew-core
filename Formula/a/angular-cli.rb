class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.2.tgz"
  sha256 "355c1b7cc82c60150a8325c2bd3e27e94240c846cc03544ff8fbf181a3cabcc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "340da3fa5a1a5ffee6c7c66c4dafce1c8e87269268275213ab07654aee7c1d61"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
