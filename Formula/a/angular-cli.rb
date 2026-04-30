class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.9.tgz"
  sha256 "530fdc9da17cb3c9134b2713941c7161e51629c6a53e47a72baeeea2755e065e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "434e3ec6e9585cf4f37d39bca34fef6c7465abae45d7c94535826b621cb6fb54"
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
