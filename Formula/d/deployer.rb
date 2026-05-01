class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.1/deployer.phar"
  sha256 "2648697028dd50cab3bb7df094b66a1e94e568e7c67a582e6e5fdbbed6341638"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "902b0df3a49ce508e270207ab70b8b360099342027f43e968a48bd6466f1c1a1"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
