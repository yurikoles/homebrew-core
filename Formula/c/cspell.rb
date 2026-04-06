class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.0.0.tgz"
  sha256 "55fb0a6b22adb900674cb01728bff1ad85ec3a60235471fac8d6b1d41655ff64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ceed6add85e7e19f0bedf78ff4b28a8eb4c41fdc41ffb471def6dd432f2fe302"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"

    # Replace code comment to build :all bottle
    node_modules = libexec/"lib/node_modules/cspell/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", ""
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
