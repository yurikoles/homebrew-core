class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/0e/e37f96177ca5227416bbf06e96d23077214fbb3968b02fe2a36c835bf49e/literategit-0.5.1.tar.gz"
  sha256 "3db9099c9618afd398444562738ef3142ef3295d1f6ce56251ba8d22385afe44"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa5c3c33cfc0dfd36ec6cbfaf9ea54ce40a08e438cb18825d5183c491fb1f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c0fd4975bbe0eea015488cfd2cd6aa3d63d758056dcc5a51eb877873ff54733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe5d950d691b41e375ce2b80fdb53968f0c4b7bc27c729266e09fc2086a8226"
    sha256 cellar: :any_skip_relocation, sonoma:        "692ecccfe5818fbf0f4faf1947530b8ff6f2022c4793798e991ecc2cc528a6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d08aec5338c04b67f400c002b8b8727df6caa12b209e9893ae997d3471e09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51040f0a845e2ee1681f70d9a0f4e938256f140989954aa9107144879802c5ab"
  end

  depends_on "pkgconf" => :build
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pygit2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e4/ae/07d4a5fcaa5509221287d289323d75ac8eda5a5a4ac9de2accf7bbcc2b88/markdown2-2.5.5.tar.gz"
    sha256 "001547e68f6e7fcf0f1cb83f7e82f48aa7d48b2c6a321f0cd20a853a8a2d1664"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~PYTHON
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    PYTHON
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
