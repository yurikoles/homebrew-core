class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/b7/b1/af95bcae8549f1f3fd70faacb29075826a0d689a27f232e8cee315efa053/markdown-3.10.1.tar.gz"
  sha256 "1c19c10bd5c14ac948c53d0d762a04e2fa35a6d58a6b7b1e6bfcbe6fefc0001a"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5291a0c598bff1e71842309bb62b509c6094369b8a82e131afe51cf3e3273526"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output("#{bin}/markdown_py test.md").strip
  end
end
