class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ca/85/5829ec57c43b4bbace4981e1b26a719438cea4575e9e9019f8e8e03e9276/translate_toolkit-3.19.6.tar.gz"
  sha256 "966a7c459a8aba6a86e504b0532dc5f29ab8ca6e852e5f78f270eddd7c8b0e95"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5a625fad34bb7cb0a41ebdc8ae210d5a74c36a46130cd4e95b8984b7fa769a6"
    sha256 cellar: :any,                 arm64_sequoia: "e8e32a4a58cbee734f012a97a77e4b3dc68df4f95219c70a16623d1afc5ea172"
    sha256 cellar: :any,                 arm64_sonoma:  "926e2d8c3243747df4752149febfe46dabbc0bc5d1b2485d6d2e3914aca5e6bb"
    sha256 cellar: :any,                 sonoma:        "81318c166eae604212050f2c165b6f238ca13782537251230cb5e4eaff9e4794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a34c4cd600241de4bd466fc9ec56742425b4ce0e1b1a45eadc33f79fa77fd73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793b73eb0f66c45525c8f13e26b76dd8412e07f8c53e6f6a3262cf09f7ba464c"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
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
