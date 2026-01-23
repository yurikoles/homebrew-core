class Selecta < Formula
  desc "Fuzzy text selector for files and anything else you need to select"
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "737aae1677fdec1781408252acbb87eb615ad3de6ad623d76c5853e54df65347"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ec55655e3c404bba347f242a7b24e7504b181fd2f364a85dad9e4c770231a79d"
  end

  uses_from_macos "ruby"

  def install
    bin.install "selecta"
  end

  test do
    system bin/"selecta", "--version"
  end
end
