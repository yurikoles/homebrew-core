class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/1c/48/e54130d57b89fc015d702e98a1a217b5757625d01a01cc07d29fd046d336/nuitka-4.0.8.tar.gz"
  sha256 "3f87e87e4d3773997944ce401145ef21461337121d39ea0fbe678274005e60ba"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96bfcc3de90d3485afb92ebbfb6896e1721f2935ad1b0e29b242247e82b9140c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065857cc5116eb682af9321275ebe8567609782bc4e14e471dd426e8f477650a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d061d1a02c582b52767a40e2a80eac30e16dff3fe887b9ece03a69acd691cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddf715eafcebf140aacb2db1ff403be4d9d39c93860fa0b44c1c3bec05dc5bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b5886a56dff76aa00355af9b04801352092570c0884bda0f4872c524399988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c898bedfde1072f1a0bacef64b831828a700fdd19b5fe79a33a40d77d69d1c"
  end

  depends_on "ccache"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("doc/*.1")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    PYTHON
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
