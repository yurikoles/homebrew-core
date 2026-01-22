class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://registry.npmjs.org/jsonlint/-/jsonlint-1.6.3.tgz"
  sha256 "987f42f0754b7bc0c84967b81fc2b4db0ed2ebe2117ccc5a5faa59e462447723"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "97762cc27f840903d10f585400d3a9019ff18813ce89ffc25cf4d13390479a13"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.json").write('{"name": "test"}')
    system bin/"jsonlint", "test.json"
  end
end
