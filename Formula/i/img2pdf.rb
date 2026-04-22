class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
  sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49cb1ad33cd2a254b41237c2ce064bda97dc24f74cfae3b81710ddb7d85be1c9"
    sha256 cellar: :any,                 arm64_sequoia: "b9fe1e781a5fae8818fdd093aba34df2ca8d39c05f44b88ba283f8fccc804d6f"
    sha256 cellar: :any,                 arm64_sonoma:  "da1e80de87f316015f4df8a677889b8b3ddee005180e289da01088ec9b22aeaa"
    sha256 cellar: :any,                 sonoma:        "9f7d81616da3c98aaf7ae9821b1790a321bcb6c5b1ddfa93ed35d1cff5f06748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8dfa6ee752c5a807e635c0dae1d411f62f0b2be1a7ea63df6367936555eacfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe8d3cf44d3c9199684b3f457b4aba7397f8c864d57ee60a0b09ac042717c60"
  end

  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "pillow"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/2c/66/32a45480d84cb239c7ad31209c956496fe5b20f6fb163d794db4c79f840c/pikepdf-10.5.1.tar.gz"
    sha256 "ffa6c7d0b77deb3af9735e0b0cae177c897431e10d342bb171b62e5527a622b7"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
