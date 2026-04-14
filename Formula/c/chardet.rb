class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/05/1d/0d102acd04cebb03377a3aa79f0c501db68bd0afbc1306e40cb208911319/chardet-7.4.2.tar.gz"
  sha256 "f2a41ccf8bf8eb1768d741e80d09b902e8d0d8c94974597e07a5d7e6a122a0dc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "237209daaa4ef552bd755a0935fbfa50910b60bac737d7150ae9e415acb63cb1"
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
