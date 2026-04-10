class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/65/89/4922b6580689b67977df95ba29dbfa339b83b62bf297a655f36201ed88c6/translate_toolkit-3.19.4.tar.gz"
  sha256 "584d1ec00a9bafe93fba22207622e87f63a846248b38385ee9021488d1763013"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8879871aba56b078b10ea24d59c00d26a28261f2c659b6bc184f13515734374f"
    sha256 cellar: :any,                 arm64_sequoia: "883874ae4c6e81e2678b72b070d699544534acd6ff85ea919414db2c004b190b"
    sha256 cellar: :any,                 arm64_sonoma:  "d620f62cee760544306cbc410e36ec2713f9b756594c2572f31378481b8c156c"
    sha256 cellar: :any,                 sonoma:        "22896ce5061695c01eb88776077830f69f00b39004f1d6170f75f86e19d52403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9897bdef73780e4e4fcac8edcf5f82bed5f26ea7f317d13bb628f89a10d603ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b944aa227f447efceb0de9279e84a9834021a66f35277f6d342aff8d2d839fff"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/43/42/149c7747977db9d68faee960c1a3391eb25e94d4bb677f8e2df8328e4098/lxml-6.0.3.tar.gz"
    sha256 "a1664c5139755df44cab3834f4400b331b02205d62d3fdcb1554f63439bf3372"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/51/f1/a72fa6016d11a186830796b63bee66260be6dfe0a5f4c09f46f6d086fd07/unicode_segmentation_rs-0.2.2.tar.gz"
    sha256 "381fc095be217a6ba08384afbf115fa48735bed66e99a3f5c1130ab43508ef5b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
