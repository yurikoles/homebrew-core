class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_tahoe:   "cb111a674b82866651a2cc13f11fac8fe37cc68e4559963f04c40ccb0cdcb06e"
    sha256 cellar: :any,                 arm64_sequoia: "5efc023a46590290af7b23c53b9dc48e76888e52182ab4630b213a61e24e7060"
    sha256 cellar: :any,                 arm64_sonoma:  "f8e0835cdd4cee5c281008aaeecd1b1bc306106f3b76cd2b7f28e58f9bc2a4ef"
    sha256 cellar: :any,                 sonoma:        "aa784301843d3bdd4ae5badde5a1336575b337fea7dcd7efc181e299134f3397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f8dd2691dfae52301c4ddf31f5e89a76b38b8cbb19025e89392a83830d62795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c891c0e81a3f78060d0d7e4df72d477d0f3dd04017b425b6b7400a8aef24d8d3"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "mdv[yaml]"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Header 1
      ## Header 2
      ### Header 3
    MARKDOWN
    system bin/"mdv", testpath/"test.md"
  end
end
