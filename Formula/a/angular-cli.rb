class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.8.tgz"
  sha256 "24b8742977c21ca28ced10821c79e4e7ca238ab627f2d9fb3ba06fc1b5fd640c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2ad3866fdad9d271341f1937024819b64f0a65b09659dd457b9556e09bcd675"
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
