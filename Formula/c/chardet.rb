class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a7/e7/58aadb0c7a4647957ef6a2a7d759f28904992632808328a1ba443a4e44d7/chardet-7.4.1.tar.gz"
  sha256 "cda41132a45dfbf6984dade1f531a4098c813caf266c66cc446d90bb9369cabd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af03e594bf8ee317227d55fe9d8d8690008fc79b9e108db85deddf61a723ceaf"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end
