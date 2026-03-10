class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/c5/76/fbc2c17511505d7ad09dbe14b32f31b1702669dc31647c5c314067e7e53a/nuitka-4.0.4.tar.gz"
  sha256 "7f36a4bef1caddc1bc80d83ab1d9e65927bbc8a773642a29a3e06659f9dc5cc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ca8911d46dacdb95e2b9ab870ad48968ae6915eecef7a5996857e631f95a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e7c66e67fdc485a49b760e11ecba36f4e4aeb5f4fe64f4dff2eed594a6acec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7532de0838108b93919e99e04c232ce13f5521262ac03686637234e38dd5287"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a99fafa22e4e1c1ae1052ad1011ef30e1998110ff879aa906f2dd51c0994d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c23f0c12a5b83ab2828d15511752dfebd0098ef11b2913cf9a0c1ea679ce1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cfc5e8f8b2100a6c926224bab3449659a276f0558c5f3aa66e925cdad334b7"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
