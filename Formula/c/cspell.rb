class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.6.1.tgz"
  sha256 "af5b156ff67eee24109fd48be6fa5ef8fa90c386395c074f310a67b658ccee89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac441bbd3b6a3785a6a3a11564cca300d8f7ebd09198414398c4e3ada1b8efb6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
