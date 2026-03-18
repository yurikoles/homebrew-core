class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.3.tgz"
  sha256 "6b17d59dfcfc4ba74fda501c55795c721ba98fe2a362e5be1eb13f0da1e8bf7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3b1c807903bb4c4f43fe4ac90c4f3f90379e71695fb929ae1c34fa5684b6129"
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
